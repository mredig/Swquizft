//
//  QuizCoordinator.swift
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
		self.questionController = questionController
	}

	func start() {
		let vc = MainViewController.instantiate(coordinator: self)
		vc.coordinator = self
		navigationController.pushViewController(vc, animated: false)
	}

	// pass in an array of questions, not just one
	func startQuiz(question: Question) {
		let vc = QuestionPromptViewController.instantiate(coordinator: self)
		vc.question = question
		rootTabController?.present(vc, animated: true)
	}
}
