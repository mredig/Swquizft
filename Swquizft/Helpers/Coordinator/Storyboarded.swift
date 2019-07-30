//
//  Storyboarded.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

protocol Storyboarded {
	static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
	static func instantiate() -> Self {
		let fullName = NSStringFromClass(self) // Swquizft.MyClassViewController

		let className = fullName.components(separatedBy: ".")[1] //MyClassViewController

		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main) // storyboard instance

		// force cast - if this doesn't work, something bad has happened and crashing is the best answer
		return storyboard.instantiateViewController(withIdentifier: className) as! Self
	}
}
