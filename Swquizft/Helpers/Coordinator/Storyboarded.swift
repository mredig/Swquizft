//
//  Storyboarded.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

protocol Storyboarded: AnyObject {
	static func instantiate() -> Self
}

protocol CoordinatedStoryboard: Storyboarded {
	static func instantiate(coordinator: Coordinator) -> Self
	var coordinator: Coordinator? { get set }
}

extension Storyboarded where Self: UIViewController {
	static func instantiate() -> Self {
		let fullName = NSStringFromClass(self) // Swquizft.MyClassViewController

		let className = fullName.components(separatedBy: ".")[1] //MyClassViewController

		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main) // storyboard instance

		// force cast - if this doesn't work, something bad has happened and crashing is the best answer
		let vc = storyboard.instantiateViewController(withIdentifier: className) as! Self
		return vc
	}
}

extension CoordinatedStoryboard where Self: UIViewController {
	static func instantiate(coordinator: Coordinator) -> Self {
		let fullName = NSStringFromClass(self) // Swquizft.MyClassViewController

		let className = fullName.components(separatedBy: ".")[1] //MyClassViewController

		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main) // storyboard instance

		// force cast - if this doesn't work, something bad has happened and crashing is the best answer
		let vc = storyboard.instantiateViewController(withIdentifier: className) as! Self
		vc.coordinator = coordinator
		return vc
	}
}
