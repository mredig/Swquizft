//
//  CategoriesCollectionViewItem.swift
//  QuestionGenerator
//
//  Created by Michael Redig on 8/11/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

protocol CategoryItemDelegate: AnyObject {
	func categoryCollectionViewItem(_ categoryCollectionViewItem: CategoriesCollectionViewItem, updatedSelection selection: Bool)
	func categoryCollectionViewItemShouldBeSelected(_ categoryCollectionViewItem: CategoriesCollectionViewItem) -> Bool
}

class CategoriesCollectionViewItem: NSCollectionViewItem {
	@IBOutlet var checkButton: NSButton!

	weak var delegate: CategoryItemDelegate?

	var category: Question.Category? {
		didSet {
			updateViews()
		}
	}

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

	private func updateViews() {
		guard let category = category else { return }
		checkButton.title = category.rawValue
		checkButton.state = (delegate?.categoryCollectionViewItemShouldBeSelected(self) ?? false) ? .on : .off
	}

	@IBAction func checkButtonToggled(_ sender: NSButton) {
		delegate?.categoryCollectionViewItem(self, updatedSelection: sender.state == .on)
		print(sender)
	}
}
