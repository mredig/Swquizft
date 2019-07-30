//
//  QuestionController.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

class QuestionController {
	var questionBank: [Question.Category: Question] = [:]
	private(set) var selectedCategories: Set<Question.Category> = []


	func select(category: Question.Category) {
		selectedCategories.insert(category)
	}

	func deselect(category: Question.Category) {
		selectedCategories.remove(category)
	}

	func categoryIsSelected(_ category: Question.Category) -> Bool {
		return selectedCategories.contains(category)
	}

	
}
