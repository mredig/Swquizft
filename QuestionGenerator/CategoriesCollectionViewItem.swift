//
//  CategoriesCollectionViewItem.swift
//  QuestionGenerator
//
//  Created by Michael Redig on 8/11/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

class CategoriesCollectionViewItem: NSCollectionViewItem {
	@IBOutlet var checkButton: NSButton!

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		commonInit()
	}

	private func commonInit() {
		let nib = NSNib(nibNamed: "CategoriesCollectionViewItem", bundle: nil)
		nib?.instantiate(withOwner: self, topLevelObjects: nil)
	}

}
