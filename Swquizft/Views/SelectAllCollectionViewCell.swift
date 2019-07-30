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

	@IBAction func selectAllButtonPressed(_ sender: UIButton) {
		delegate?.toggleAllSelection()
	}
}
