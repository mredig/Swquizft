//
//  QuestionsManagerViewController.swift
//  Swquizft
//
//  Created by Michael Redig on 7/30/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class QuestionsManagerViewController: UIViewController, CoordinatedStoryboard {
	var coordinator: Coordinator?
	
	@IBOutlet var difficultySegmentedControl: UISegmentedControl!

	override func viewDidLoad() {
		super.viewDidLoad()

		difficultySegmentedControl.removeAllSegments()
		for difficulty in Question.Difficulty.allCases.reversed() {
			difficultySegmentedControl.insertSegment(withTitle: difficulty.stringValue, at: 0, animated: false)
		}
		difficultySegmentedControl.selectedSegmentIndex = 0

	}
}
