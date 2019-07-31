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

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}

	func start() {
		let vc = MainViewController.instantiate()
		vc.coordinator = self
		navigationController.pushViewController(vc, animated: false)
	}

	// pass in an array of questions, not just one
	func startQuiz(question: Question) {
		let vc = QuestionPromptViewController.instantiate()
		vc.question = question
		rootTabController?.present(vc, animated: true)
	}
}
