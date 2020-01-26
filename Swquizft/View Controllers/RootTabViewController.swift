//
//  RootTabViewController.swift
//  Swquizft
//
//  Created by Michael Redig on 7/30/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class RootTabViewController: UITabBarController {

	let questionsController: QuestionController

	let quizCoordinator: MainCoordinator

	init() {
		let aQuestionsController = QuestionController()
		self.questionsController = aQuestionsController
		self.quizCoordinator = MainCoordinator(questionController: aQuestionsController)
		super.init(nibName: nil, bundle: nil)

		aQuestionsController.questionBankURL = Bundle.main.url(forResource: "QuizQuestions", withExtension: "swquiz")
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		quizCoordinator.rootTabController = self
		quizCoordinator.start()
		setViewControllers([quizCoordinator.navigationController], animated: false)

		tabBar.tintColor = UIColor(named: "swiftlikeOrange")
    }

}
