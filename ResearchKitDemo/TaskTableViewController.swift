//
//  TaskTableViewController.swift
//  ResearchKitDemo
//
//  Created by Uldis Zingis on 28/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit
import ResearchKit

class TaskTableViewController: UITableViewController, ORKTaskViewControllerDelegate {

    enum TaskRow: Int {
        case painSurvey = 0
        case audioTask = 1
    }

    // MARK: - Computed properties

    var painSurvey: ORKOrderedTask {
        var steps = [ORKStep]()

        let introStep = ORKInstructionStep(identifier: "Intro Step")
        introStep.title = "Pain Survey"
        introStep.text = "Please answer these questions based on how you feel today"
        steps.append(introStep)

        let painChoices: [ORKTextChoice] = [
            ORKTextChoice(text: "Terrible", detailText: "The pain was so bad I could have cried", value: 0 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Average", detailText: "Manageable, like it is most days", value: 1 as NSNumber, exclusive: false),
            ORKTextChoice(text: "Great", detailText: "Much better than usual", value: 2 as NSNumber, exclusive: false)
        ]

        let questioOneTitle = "How did you feel this morning after breakfast?"
        let questionOneAnswerFormat = ORKTextChoiceAnswerFormat(style: .multipleChoice, textChoices: painChoices)
        let questionOneStep: ORKStep = ORKQuestionStep(identifier: "Question One", title: questioOneTitle, answer: questionOneAnswerFormat)
        questionOneStep.isOptional = true
        steps.append(questionOneStep)

        let questionTwoTitle = "How did you feel this evening after dinner?"
        let questionTwoAnsferFormat = ORKTextChoiceAnswerFormat(style: .singleChoice, textChoices: painChoices)
        let questionTwoStep = ORKQuestionStep(identifier: "Question Two", title: questionTwoTitle, answer: questionTwoAnsferFormat)
        questionTwoStep.isOptional = false
        steps.append(questionTwoStep)

        let summaryStep = ORKCompletionStep(identifier: "Competion Step")
        summaryStep.title = "Thank you for completing the Pain Survey"
        summaryStep.text = "Please remember to take the pain survey every day"
        steps.append(summaryStep)

        return ORKOrderedTask(identifier: "PainSurvey", steps: steps)
    }
    
    var audioActiveTask: ORKOrderedTask {
        return ORKOrderedTask.audioTask(withIdentifier: "Audio Task", intendedUseDescription: "So we can measure your stability", speechInstruction: "Once the activity starts, take a deep breath and say \"Aaaaah\" into the microphone.", shortSpeechInstruction: nil, duration: 5, recordingSettings: nil, checkAudioLevel: true, options: [])
    }

    // MARK: - UITableViewControllerDelegate Protocol

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var taskViewController: ORKTaskViewController?

        switch indexPath.row {
        case TaskRow.painSurvey.rawValue:
            taskViewController = ORKTaskViewController(task: self.painSurvey, taskRun: UUID())
        case TaskRow.audioTask.rawValue:
            taskViewController = ORKTaskViewController(task: self.audioActiveTask, taskRun: UUID())
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let url = URL(fileURLWithPath: path, isDirectory: true)
            taskViewController?.outputDirectory = url
        default:
            ()
        }

        if let taskViewController = taskViewController {
            taskViewController.delegate = self
            self.present(taskViewController, animated: true, completion: nil)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - ORKTaskViewControllerDelegate protocol

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
