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

	/// QuestionBank file location - when this gets set, it triggers a load from persistence, if the file already exists. If this value is being set with the intention to overwrite the existing file on disk, delete/rename the existing file before setting this value.
	var questionBankURL: URL? {
		didSet {
			loadFromPersistence()
		}
	}

	/// The current quiz questions
	var currentQuestions: [Question] = []

	/// Statistics tracker for performance within categories
	private(set) var categoryStatistics = CategoryStatistics() {
		didSet {
			saveCategoryStatistics()
		}
	}

	init() {
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
		// FIXME: needs full implementation - this is just a hacky test value
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

	// MARK: - Question CRUD
	func createQuestionWith(prompt: String, answers: [Answer], categoryTags: Set<Question.Category>, difficulty: Question.Difficulty) {
		let question = Question(prompt: prompt, answers: answers, categoryTags: categoryTags, difficulty: difficulty)
		questionBank.append(question)
	}

	func update(question: Question, withPrompt prompt: String, answers: [Answer], categoryTags: Set<Question.Category>, difficulty: Question.Difficulty) {
		guard let questionIndex = questionBank.firstIndex(of: question) else { return }
		let updatedQuestion = Question(prompt: prompt, answers: answers, categoryTags: categoryTags, difficulty: difficulty)
		questionBank[questionIndex] = updatedQuestion
	}

	// MARK: - persistence

	func loadFromPersistence() {
		questionBank = []
		guard let fileURL = questionBankURL, FileManager.default.fileExists(atPath: fileURL.path) else { return }
		do {
			let data = try Data(contentsOf: fileURL)
			questionBank = try JSONDecoder().decode([Question].self, from: data)
		} catch {
			NSLog("error opening: \(error)")
		}
	}

	// currently has a lot of hardcoded stuff for testing
	func saveToPersistence() {
		guard let fileURL = questionBankURL else { return }

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
