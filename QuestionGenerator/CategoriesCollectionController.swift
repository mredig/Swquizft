//
//  CategoriesCollectionController.swift
//  QuestionGenerator
//
//  Created by Michael Redig on 8/11/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

class CategoriesCollectionController: NSObject, NSCollectionViewDelegate, NSCollectionViewDataSource {
	let questionController: QuestionController

	init(questionController: QuestionController) {
		self.questionController = questionController
		super.init()
	}

	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		return Question.Category.allCases.count
	}

	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("CategoriesCell"), for: indexPath)
		guard let categoryCell = cell as? CategoriesCollectionViewItem else { return cell }

		categoryCell.checkButton.title = Question.Category.allCases[indexPath.item].rawValue

		return categoryCell
	}

}

extension CategoriesCollectionController: NSCollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
		return NSSize(width: 130, height: 50)
	}
}
