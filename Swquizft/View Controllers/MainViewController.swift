//
//  MainViewController
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, CoordinatedStoryboard {
	@IBOutlet var difficultyButtons: [UIButton]!
	@IBOutlet var easyButton: UIButton!
	@IBOutlet var mediumButton: UIButton!
	@IBOutlet var hardButton: UIButton!
	@IBOutlet var categoryCollection: UICollectionView!
	var categoryDelegate: CategoryCollectionDelegate?

	var questionsController: QuestionController?
	var coordinator: Coordinator? {
		didSet {
			guard let quizCoordinator = mainCoordinator else { return }
			questionsController = quizCoordinator.questionController
		}
	}
	var mainCoordinator: MainCoordinator? {
		return coordinator as? MainCoordinator
	}


	override func viewDidLoad() {
		super.viewDidLoad()
		guard let questionsController = mainCoordinator?.questionController else { return }
		categoryDelegate = CategoryCollectionDelegate(questionController: questionsController, categoryCollection: categoryCollection)
		categoryCollection.delegate = categoryDelegate
		categoryCollection.dataSource = categoryDelegate
		categoryCollection.allowsMultipleSelection = true

		setupDifficultyButtons()

		difficultyButtons.first?.isSelected = true
	}

	func setupDifficultyButtons() {
		for (index, button) in difficultyButtons.enumerated() {
			let difficulty = Question.Difficulty.allCases[index].stringValue
			button.setTitle(difficulty, for: .normal)
		}
	}

	@IBAction func difficultyPressed(_ sender: UIButton) {
		difficultyButtons.forEach { $0.isSelected = sender == $0 }
	}

	@IBAction func goButtonPressed(_ sender: UIButton) {
		mainCoordinator?.startQuiz()
	}
}

