//
//  CategoryCollectionSelector.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class CategoryCollectionSelector: NSObject {
	let questionController: QuestionController
	let categoryCollection: UICollectionView

	init(questionController: QuestionController, categoryCollection: UICollectionView) {
		self.questionController = questionController
		self.categoryCollection = categoryCollection
	}
}

extension CategoryCollectionSelector: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		default:
			return Question.Category.allCases.count
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.section == 0 {
			return selectAllCell(from: collectionView, at: indexPath)
		} else {
			return categorySelectionCell(from: collectionView, at: indexPath)
		}
	}

	private func selectAllCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> SelectAllCollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectAllCollectionViewCell", for: indexPath)
		guard let selectCell = cell as? SelectAllCollectionViewCell else { return SelectAllCollectionViewCell() }
		selectCell.delegate = self
		return selectCell
	}

	private func categorySelectionCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> CategoryCollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorySelectionCell", for: indexPath)
		guard let catCell = cell as? CategoryCollectionViewCell else { return CategoryCollectionViewCell() }
		catCell.questionsController = questionController
		catCell.category = Question.Category.allCases[indexPath.item]
		return catCell
	}

}

extension CategoryCollectionSelector: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		(collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell)?.toggleSelection()
	}
}

extension CategoryCollectionSelector: UICollectionViewDelegateFlowLayout {
}

extension CategoryCollectionSelector: SelectionController {
	func toggleAllSelection() {
		if questionController.selectedCategories.count == Question.Category.allCases.count {
			for category in Question.Category.allCases {
				questionController.deselect(category: category)
			}
		} else {
			for category in Question.Category.allCases {
				questionController.select(category: category)
			}
		}
		categoryCollection.reloadData()
	}
}
