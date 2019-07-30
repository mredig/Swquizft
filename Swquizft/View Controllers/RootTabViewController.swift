//
//  RootTabViewController.swift
//  Swquizft
//
//  Created by Michael Redig on 7/30/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class RootTabViewController: UITabBarController, Storyboarded {

	var questionCoordinator: QuizCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
		let navController = UINavigationController()

		questionCoordinator = QuizCoordinator(navigationController: navController)
		questionCoordinator?.start()
		setViewControllers([navController], animated: false)
    }

}
