//
//  QuestionController.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

class QuestionController {
	var questionBank: [Question] = []
	private(set) var selectedCategories: Set<Question.Category> = []

	init() {
		saveToPersistence()
		loadFromPersistence()
	}

	func select(category: Question.Category) {
		selectedCategories.insert(category)
	}

	func deselect(category: Question.Category) {
		selectedCategories.remove(category)
	}

	func categoryIsSelected(_ category: Question.Category) -> Bool {
		return selectedCategories.contains(category)
	}

	func loadFromPersistence() {
		let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
			.appendingPathComponent("sample questions").appendingPathExtension("json")
		do {
			let data = try Data(contentsOf: fileURL)
			questionBank = try JSONDecoder().decode([Question].self, from: data)
		} catch {
			NSLog("error opening: \(error)")
		}
	}

	func saveToPersistence() {
		let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
						.appendingPathComponent("sample questions").appendingPathExtension("json")

		let aDocumentAnswer = Answer(answerText: "aDocument", isCorrect: true, reason: nil)
		let documentAnswer = Answer(answerText: "Document", isCorrect: false, reason: "// this is a short reason")
		let letAnswer = Answer(answerText: "let", isCorrect: false, reason: "// because that's dumb!\nand so is your face!\nEAT IT!")
		let equalAnswer = Answer(answerText: "=\nthis is a long answer\non multiple lines\nsee?\nthere are several", isCorrect: false, reason: nil)

		let question1 = Question(prompt: """
							// Identify the name of the variable in the following code:

							let aDocument = Document()

							""", answers: [aDocumentAnswer, documentAnswer, letAnswer, equalAnswer], categoryTags: [.syntax, .vocab], difficulty: .beginner)

		let aDocumentAnswer2 = Answer(answerText: "`aDocument`", isCorrect: false, reason: nil)
		let documentAnswer2 = Answer(answerText: "`Document`", isCorrect: true, reason: nil)
		let question2 = Question(prompt: """
							Identify the type of the variable in this snippet:
							```swift
							let aDocument = Document()
							```
							""", answers: [aDocumentAnswer2, documentAnswer2, letAnswer, equalAnswer], categoryTags: [.syntax, .vocab], difficulty: .beginner)

		questionBank = [question1, question2]

		do {
			let data = try JSONEncoder().encode(questionBank)
			try data.write(to: fileURL)
		} catch {
			NSLog("error saving: \(error)")
		}


	}
}
