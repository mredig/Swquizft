//
//  MainCoordinator.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class MainCoordinator: NSObject, Coordinator {
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController
	var rootTabController: UITabBarController?

	let questionController: QuestionController

	init(navigationController: UINavigationController = UINavigationController(), questionController: QuestionController) {
		self.navigationController = navigationController
		self.questionController = questionController
	}

	func start() {
		let vc = MainViewController(mainCoordinator: self)
		navigationController.pushViewController(vc, animated: false)
	}

	// pass in an array of questions, not just one
	func startQuiz() {
		questionController.prepareCurrentQuizQuestions()
		let quizCoord = QuizCoordinator(questionController: questionController)
		quizCoord.rootTabController = rootTabController
		childCoordinators.append(quizCoord)
		quizCoord.start()
	}
}
