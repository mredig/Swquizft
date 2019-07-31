//
//  QuizCoordinator.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class CreationCoordinator: NSObject, Coordinator {
	var childCoordinators: [Coordinator] = []
	var navigationController: UINavigationController

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
	}

	func start() {
		let vc = QuestionsManagerViewController.instantiate()
		navigationController.pushViewController(vc, animated: false)
	}
}
