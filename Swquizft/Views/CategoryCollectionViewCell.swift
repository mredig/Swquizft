//
//  CategoryCollectionViewCell.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var contentsContainer: UIView!
	@IBOutlet var titleLabel: UILabel!

	private var _isSelected = false
	override var isSelected: Bool {
		get {
			return _isSelected
		}
		set {
			_isSelected = newValue
			updateViews()
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		contentsContainer.layer.borderColor = UIColor.gray.cgColor
		contentsContainer.layer.borderWidth = 1
		contentsContainer.layer.cornerRadius = 10
	}

	private func updateViews() {
		titleLabel.textColor = isSelected ? .black : .gray
	}
}
