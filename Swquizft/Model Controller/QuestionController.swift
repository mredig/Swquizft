//
//  QuestionController.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

class QuestionController {
	/// bank of all questions. Probably not a long term solution
	var questionBank: [Question] = []
	/// Set indicating selected categories. When a quiz is started, a random selection of questions pertaining only to
	/// categories selected is pulled from the master list and presented to the user
	private(set) var selectedCategories: Set<Question.Category> = []

	/// The current quiz questions
	var currentQuestions: [Question] = []

	/// Statistics tracker for performance within categories
	private(set) var categoryStatistics = CategoryStatistics() {
		didSet {
			saveCategoryStatistics()
		}
	}

	init() {
		saveToPersistence()
		loadFromPersistence()
		loadCategoryStatistics()
	}

	// MARK: - Category Selection
	/// Adds a category to `selectedCategories`
	func select(category: Question.Category) {
		selectedCategories.insert(category)
	}

	/// Removes a category from `selectedCategories`
	func deselect(category: Question.Category) {
		selectedCategories.remove(category)
	}

	/// Returns a boolean indicating if the input category is currently in the `selectedCategories`
	func categoryIsSelected(_ category: Question.Category) -> Bool {
		return selectedCategories.contains(category)
	}

	// MARK: - Quiz Controlling
	/// Filter through all available questions, selecting only ones that conform to the matching selected categories, then compile a reasonable amount of them into `currentQuestions`
	func prepareCurrentQuizQuestions() {
		// TODO: needs full implementation - this is just a hacky test value
		currentQuestions = questionBank
	}

	func question(_ question: Question, answeredCorrectly correct: Bool) {
		for category in question.categoryTags {
			categoryStatistics.presented(category: category, correct: correct)
		}
		if !correct {
			// append to end of current question list for immediate review
			currentQuestions.append(question)
		}
	}

	// MARK: - persistence
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

	// currently has a lot of hardcoded stuff for testing
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

	private func saveCategoryStatistics() {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(categoryStatistics)
			UserDefaults.standard.set(data, forKey: "categoryStatistics")
		} catch {
			NSLog("Statistics saving failed: \(error)")
		}
	}

	private func loadCategoryStatistics() {
		guard let data = UserDefaults.standard.data(forKey: "categoryStatistics") else { return }
		let decoder = PropertyListDecoder()
		do {
			let stats = try decoder.decode(CategoryStatistics.self, from: data)
			categoryStatistics = stats
		} catch {
			NSLog("Statistics loading failed: \(error)")
		}
	}
}
