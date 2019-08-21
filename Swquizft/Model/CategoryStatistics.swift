//
//  CategoryStatistics.swift
//  Swquizft
//
//  Created by Michael Redig on 8/2/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct CategoryStatistics: Codable {
	struct CategoryTracking: Codable {
		var presented: Int
		var correct: Int
		var percentage: Double {
			return Double(correct) / Double(presented)
		}
	}
	private(set) var statistics = [Question.Category: CategoryTracking]()
	var statsticsArray: [(category: Question.Category, tracking: CategoryStatistics.CategoryTracking)] {
		return statistics
			.map { ($0.key, $0.value) }
			.sorted { $0.tracking.percentage < $1.tracking.percentage }
	}

	mutating func presented(category: Question.Category, correct: Bool) {
		var tracker = statistics[category, default: CategoryTracking(presented: 0, correct: 0)]
		tracker.presented += 1
		if correct {
			tracker.correct += 1
		}
		statistics[category] = tracker
	}
}
