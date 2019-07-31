//
//  RootTabViewController.swift
//  Swquizft
//
//  Created by Michael Redig on 7/30/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class RootTabViewController: UITabBarController, Storyboarded {

	let questionCoordinator = QuizCoordinator()
//	let creationCoordinator = CreationCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()

		questionCoordinator.start()
//		creationCoordinator.start()
		setViewControllers([questionCoordinator.navigationController], animated: false)

		tabBar.tintColor = UIColor(named: "swiftlikeOrange")
    }

}
