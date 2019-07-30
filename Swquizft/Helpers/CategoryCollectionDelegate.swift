//
//  CategoryCollectionDelegate.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit


class CategoryCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		default:
			return Question.Categories.allCases.count
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorySelectionCell", for: indexPath)
		guard let catCell = cell as? CategoryCollectionViewCell else { return cell }
		catCell.isSelected = false

		if indexPath.section == 0 {
			catCell.titleLabel.text = "random"
		} else {
			catCell.titleLabel.text = Question.Categories.allCases[indexPath.item].rawValue
		}

		return catCell
	}
}

extension CategoryCollectionDelegate: UICollectionViewDelegateFlowLayout {


}
