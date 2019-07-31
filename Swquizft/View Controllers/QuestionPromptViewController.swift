//
//  QuestionPromptViewController.swift
//  Swquizft
//
//  Created by Michael Redig on 7/31/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class QuestionPromptViewController: UIViewController, Storyboarded {
	@IBOutlet var questionTextView: UITextView!
	@IBOutlet var answerTableView: UITableView!

	var question: Question? {
		didSet {
			updateViews()
			updateAnswers()
		}
	}
	var answers: [Answer] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		answerTableView.dataSource = self
		answerTableView.delegate = self
	}

	private func updateViews() {
		guard let question = question else { return }
		loadViewIfNeeded()
		questionTextView.attributedText = MarkdownHelper.convertFromMarkdown(question.prompt)
	}

	private func updateAnswers() {
		guard let question = question else { return }
		answers = question.answers.shuffled()
		answerTableView.reloadData()
	}
}


extension QuestionPromptViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return answers.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
		guard let answerCell = cell as? AnswerTableViewCell else { return cell }
		answerCell.answer = answers[indexPath.row]
		return answerCell
	}
}
