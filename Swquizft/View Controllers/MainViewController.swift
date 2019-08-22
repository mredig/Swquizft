//
//  MainViewController
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	@IBOutlet var difficultyButtons: [UIButton]!
	@IBOutlet var easyButton: UIButton!
	@IBOutlet var mediumButton: UIButton!
	@IBOutlet var hardButton: UIButton!
	@IBOutlet var goButton: UIButton!
	@IBOutlet private var _tabBarItemInXib: UITabBarItem!
	override var tabBarItem: UITabBarItem! {
		get {
			return _tabBarItemInXib
		}
		set {
			_tabBarItemInXib = newValue
		}
	}
	@IBOutlet var categoryCollection: UICollectionView!
	var categoryDelegate: CategoryCollectionSelector?
	
	let questionController: QuestionController
	let mainCoordinator: MainCoordinator

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		fatalError("init(nibName etc not implemented)")
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(mainCoordinator: MainCoordinator) {
		self.mainCoordinator = mainCoordinator
		self.questionController = mainCoordinator.questionController
		super.init(nibName: nil, bundle: nil)
		commonInit()
	}

	private func commonInit() {
		let nib = UINib(nibName: "MainViewController", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		categoryDelegate = CategoryCollectionSelector(questionController: questionController, categoryCollection: categoryCollection)
		categoryCollection.delegate = categoryDelegate
		categoryCollection.dataSource = categoryDelegate
		categoryCollection.allowsMultipleSelection = true

		categoryCollection.register(SelectAllCollectionViewCell.self, forCellWithReuseIdentifier: "SelectAllCollectionViewCell")
		categoryCollection.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategorySelectionCell")

		setupDifficultyButtons()

		difficultyButtons.first?.isSelected = true
		questionController.delegate = self
		updateGoButton()
	}

	func setupDifficultyButtons() {
		for (index, button) in difficultyButtons.enumerated() {
			let difficulty = Question.Difficulty.allCases[index].stringValue
			button.setTitle(difficulty, for: .normal)
			button.isHidden = true
		}
	}

	@IBAction func difficultyPressed(_ sender: UIButton) {
		difficultyButtons.forEach { $0.isSelected = sender == $0 }
	}

	@IBAction func goButtonPressed(_ sender: UIButton) {
		mainCoordinator.startQuiz()
	}

	private func updateGoButton() {
		goButton.isEnabled = questionController.selectedCategories.isEmpty == false
	}
}

extension MainViewController: QuestionControllerDelegate {
	func questionControllerSelectedCategoriesChanged(_ questionController: QuestionController) {
		updateGoButton()
	}
}
