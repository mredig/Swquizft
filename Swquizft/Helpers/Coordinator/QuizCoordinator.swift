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
		self.questionController = questionController
		super.init()
		navigationController.navigationBar.prefersLargeTitles = true
		navigationController.navigationBar.barStyle = .blackTranslucent
		navigationController.delegate = self
		navigationController.navigationBar.tintColor = UIColor(named: "swiftlikeOrange")
	}

	private(set) var currentQuestionIndex = 0 {
		didSet {
			NotificationCenter.default.post(name: .quizIndexChanged, object: nil)
		}
	}
	func start() {
		showNextViewController(incrementingIndex: false)
		rootTabController?.present(navigationController, animated: true)
	}

	func showNextViewController(incrementingIndex: Bool) {
		currentQuestionIndex = incrementingIndex ? currentQuestionIndex + 1 : currentQuestionIndex
		if currentQuestionIndex > questionController.currentQuestions.count - 1 {
			// reached end of questions
			currentQuestionIndex -= 1
		} else {
			showQuestionVC()
		}
	}

	func showQuestionVC() {
		let quizVC = QuestionPromptViewController.instantiate(coordinator: self)
		quizVC.questionController = questionController
		quizVC.question = questionController.currentQuestions[currentQuestionIndex]
		navigationController.pushViewController(quizVC, animated: true)
	}

	func backButtonPressed() {
		currentQuestionIndex -= 1
		currentQuestionIndex = max(currentQuestionIndex, 0)
	}

	func quitQuiz() {
		rootTabController?.dismiss(animated: true)
	}

	func generateVCTitle() -> String {
		return "\(currentQuestionIndex + 1) / \(questionController.currentQuestions.count)"
	}
}

extension QuizCoordinator: UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		// get vc we are moving from
		guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

		// check if it is in navigation stack (if it is in the view stack, we are going forward, if it's not, it was just removed and we are going backward)
		if navigationController.viewControllers.contains(fromVC) {
			return
		}

		// if we are still here, that means we are popping the top vc
		backButtonPressed()
	}
}

extension NSNotification.Name {
	static let quizIndexChanged = NSNotification.Name(rawValue: "com.redeggproductions.quizIndexChanged")
}
