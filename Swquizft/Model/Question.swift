//
//  QuizQuestion.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct Question: Codable {
	enum Category: String, Codable, CaseIterable {
		case syntax
		case types
		case extensions
		case vocab
		case misc
	}

	static func category(from string: String) -> Category {
		if let newCat = Category(rawValue: string.lowercased()) {
			return newCat
		}
		return Category.misc
	}

	enum Difficulty: Int, Codable, CaseIterable {
		case beginner
		case intermediate
		case advanced

		var stringValue: String {
			switch self {
			case .beginner:
				return "beginner"
			case .intermediate:
				return "intermediate"
			case .advanced:
				return "advanced"
			}
		}
	}

	let prompt: String
	let answers: [Answer]
	let categoryTags: Set<Category>
	let difficulty: Difficulty
}
