//
//  SelectAllCollectionViewCell.swift
//  Swquizft
//
//  Created by Michael Redig on 7/30/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

protocol SelectionController: AnyObject {
	func toggleAllSelection()
}

class SelectAllCollectionViewCell: UICollectionViewCell {
	weak var delegate: SelectionController?
	@IBOutlet var contentsContainer: UIView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		let nib = UINib(nibName: "SelectAllCollectionViewCell", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		addSubview(contentsContainer)
		contentsContainer.translatesAutoresizingMaskIntoConstraints = false
		contentsContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentsContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		contentsContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentsContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}


	@IBAction func selectAllButtonPressed(_ sender: UIButton) {
		delegate?.toggleAllSelection()
	}
}
