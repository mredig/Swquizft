//
//  QuizQuestion.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct Question: Codable {
	enum Categories: String, Codable {
		case syntax
		case types
		case extensions
	}

	enum Difficulty: Int, Codable {
		case beginner
		case intermediate
		case advanced
	}

	let prompt: String
	let answers: [Answer]
	let categoryTags: Set<Categories>
	let difficulty: String
}
