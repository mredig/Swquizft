//
//  QuestionPromptViewController.swift
//  Swquizft
//
//  Created by Michael Redig on 7/31/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit
import Sourceful

class QuestionPromptViewController: UIViewController, CoordinatedStoryboard {
	var coordinator: Coordinator?
	var quizCoordinator: QuizCoordinator? {
		return coordinator as? QuizCoordinator
	}
	
	@IBOutlet var questionTextView: SwiftCodeTextView!
	@IBOutlet var questionHeightConstraint: NSLayoutConstraint!
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var answerStackView: UIStackView!
	@IBOutlet var nextButton: UIBarButtonItem!

	private var quizChangedNotification: NSObjectProtocol?

	var questionController: QuestionController?

	let lexer = SwiftLexer()

	var question: Question? {
		didSet {
			updateViews()
			updateAnswers()
		}
	}
	var answers: [Answer] = []
	var firstAttempt = true

	override func viewDidLoad() {
		super.viewDidLoad()
		setupScrollView()

		quizChangedNotification = NotificationCenter.default.addObserver(forName: .quizIndexChanged, object: nil, queue: nil) { _ in
			self.updateViews()
		}
	}

	deinit {
		quizChangedNotification = nil
	}

	private func setupScrollView() {

		scrollView.addSubview(answerStackView)
		answerStackView.translatesAutoresizingMaskIntoConstraints = false

		answerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
		answerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
		answerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
		answerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
		answerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
	}

	private func updateViews() {
		guard let question = question else { return }
		loadViewIfNeeded()
		questionTextView.text = question.prompt

		questionHeightConstraint.constant = questionTextView.requiredHeight(for: view.frame.width)

		navigationItem.title = quizCoordinator?.generateVCTitle()
		nextButton.title = quizCoordinator?.generateNextButtonText()
	}

	private func updateAnswers() {
		guard let question = question else { return }
		answers = question.answers.shuffled()

		for answer in answers {
			let answerView = AnswerView(answer: answer)
			answerView.delegate = self
			answerStackView.addArrangedSubview(answerView)
		}
	}

	@IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
		quizCoordinator?.showNextViewController(incrementingIndex: true)
	}

	@IBAction func quitButtonPressed(_ sender: UIBarButtonItem) {
		quizCoordinator?.quitQuiz()
	}

}

extension QuestionPromptViewController: AnswerViewDelegate {
	func answerView(_ answerView: AnswerView, revealedAnswer answer: Answer) {
		guard let question = question else { return }
		if firstAttempt {
			// update question controller
			questionController?.question(question, answeredCorrectly: answer.isCorrect)
			firstAttempt = false
		}
		if answer.isCorrect {
			nextButton.isEnabled = true
		}
		updateViews()
	}
}
