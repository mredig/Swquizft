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
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var answerStackView: UIStackView!
	@IBOutlet var nextButton: UIBarButtonItem!

	var questionController: QuestionController?

	let lexer = SwiftLexer()

	var question: Question? {
		didSet {
			updateViews()
			updateAnswers()
		}
	}
	var answers: [Answer] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		setupScrollView()
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

		if question == questionController?.currentQuestions.last {
			nextButton.isEnabled = false
		}
	}

	private func updateAnswers() {
		guard let question = question else { return }
		answers = question.answers.shuffled()

		for answer in answers {
			let answerView = AnswerView(answer: answer)
			answerView.edgeInsets.left = 50
			answerView.edgeInsets.right = 20
			answerStackView.addArrangedSubview(answerView)
		}
	}

	@IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
		quizCoordinator?.nextQuestion()
	}

	@IBAction func quitButtonPressed(_ sender: UIBarButtonItem) {
		quizCoordinator?.quitQuiz()
	}
}
