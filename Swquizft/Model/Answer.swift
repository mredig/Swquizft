//
//  QuizAnswer.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct Answer: Codable, Equatable {
	let answerText: String
	let isCorrect: Bool
	let reason: String?
}
