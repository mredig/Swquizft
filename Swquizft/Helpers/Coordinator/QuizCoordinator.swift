//
//  MainCoordinator.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class QuizCoordinator: NSObject, Coordinator {
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController
	var rootTabController: UITabBarController?

	let questionController: QuestionController

	init(navigationController: UINavigationController = UINavigationController(), questionController: QuestionController) {
		self.navigationController = navigationController
		navigationController.navigationBar.prefersLargeTitles = true
		self.questionController = questionController
	}

	private(set) var currentQuestionIndex = 0
	func start() {
		let quizVC = QuestionPromptViewController.instantiate(coordinator: self)
		quizVC.coordinator = self
		quizVC.question = questionController.currentQuestions[currentQuestionIndex]

		quizVC.title = generateVCTitle()

		navigationController.pushViewController(quizVC, animated: false)
		rootTabController?.present(navigationController, animated: true)
	}


	private func generateVCTitle() -> String {
		return "\(currentQuestionIndex + 1) / \(questionController.currentQuestions.count)"
	}
}
