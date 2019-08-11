//
//  CategoriesCollectionController.swift
//  QuestionGenerator
//
//  Created by Michael Redig on 8/11/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

class CategoriesCollectionController: NSObject {
	let questionController: QuestionController
	let collectionView: NSCollectionView

	var selectedQuestion: Int? {
		didSet {
			updateViews()
		}
	}
	var selectedQuestionCategories: Set<Question.Category> {
		get {
			return questionController.selectedCategories
		}
		set {
			Question.Category.allCases.forEach { questionController.deselect(category: $0) }
			for value in newValue {
				questionController.select(category: value)
			}
		}
	}

	init(questionController: QuestionController, collectionView: NSCollectionView) {
		self.questionController = questionController
		self.collectionView = collectionView
		super.init()
	}

	private func updateViews() {
		guard let selectedQuestion = selectedQuestion else { return }
		let question = questionController.questionBank[selectedQuestion]
		selectedQuestionCategories = question.categoryTags
		collectionView.reloadData()
	}
}

extension CategoriesCollectionController: NSCollectionViewDelegate, NSCollectionViewDataSource {
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return Question.Category.allCases.count
	}

	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("CategoriesCell"), for: indexPath)
		guard let categoryCell = cell as? CategoriesCollectionViewItem else { return cell }

		categoryCell.delegate = self
		categoryCell.category = Question.Category.allCases[indexPath.item]

		return categoryCell
	}
}

extension CategoriesCollectionController: NSCollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		return NSSize(width: 130, height: 50)
	}
}

extension CategoriesCollectionController: CategoryItemDelegate {
	func categoryCollectionViewItem(_ categoryCollectionViewItem: CategoriesCollectionViewItem, updatedSelection selection: Bool) {
		guard let category = categoryCollectionViewItem.category else { return }
		if selection {
			questionController.select(category: category)
		} else {
			questionController.deselect(category: category)
		}
	}

	func categoryCollectionViewItemShouldBeSelected(_ categoryCollectionViewItem: CategoriesCollectionViewItem) -> Bool {
		guard let category = categoryCollectionViewItem.category else { return false }
		return questionController.categoryIsSelected(category)
	}


}
