//
//  QuestionController.swift
//  Swquizft
//
//  Created by Michael Redig on 7/29/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

protocol QuestionControllerDelegate: AnyObject {
	func questionControllerSelectedCategoriesChanged(_ questionController: QuestionController)
}

class QuestionController {
	/// bank of all questions. Probably not a long term solution
	var questionBank: [Question] = []
	/// Set indicating selected categories. When a quiz is started, a random selection of questions pertaining only to
	/// categories selected is pulled from the master list and presented to the user
	private(set) var selectedCategories: Set<Question.Category> = [] {
		didSet {
			delegate?.questionControllerSelectedCategoriesChanged(self)
		}
	}

	/// QuestionBank file location - when this gets set, it triggers a load from persistence, if the file already exists. If this value is being set with the intention to overwrite the existing file on disk, delete/rename the existing file before setting this value.
	var questionBankURL: URL? {
		didSet {
			loadFromPersistence()
		}
	}

	/// The current quiz questions
	var currentQuestions: [Question] = []

	/// Statistics tracker for performance within categories
	private(set) var allTimeCategoryStatistics = CategoryStatistics() {
		didSet {
			saveCategoryStatistics()
		}
	}
	private(set) var thisTimeCategoryStatistics: CategoryStatistics?

	weak var delegate: QuestionControllerDelegate?

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
		currentQuestions = questionBank.filter {
			for category in $0.categoryTags {
				if selectedCategories.contains(category) {
					return true
				}
			}
			return false
		}
		currentQuestions.shuffle()
		while currentQuestions.count > 10 {
			currentQuestions.removeLast()
		}
		thisTimeCategoryStatistics = CategoryStatistics()
	}

	func question(_ question: Question, answeredCorrectly correct: Bool) {
		for category in question.categoryTags {
			allTimeCategoryStatistics.presented(category: category, correct: correct)
			thisTimeCategoryStatistics?.presented(category: category, correct: correct)
		}
		if !correct {
			// append to end of current question list for immediate review
			currentQuestions.append(question)
		}
	}

	// MARK: - Question CRUD
	func createQuestionWith(prompt: String, answers: [Answer], categoryTags: Set<Question.Category>, difficulty: Question.Difficulty) {
		let answers = answers.sorted { $0.isCorrect != $1.isCorrect && $0.isCorrect == true }
		let question = Question(prompt: prompt, answers: answers, categoryTags: categoryTags, difficulty: difficulty)
		questionBank.append(question)
	}

	func update(question: Question, withPrompt prompt: String, answers: [Answer], categoryTags: Set<Question.Category>, difficulty: Question.Difficulty) {
		guard let questionIndex = questionBank.firstIndex(of: question) else { return }
		let answers = answers.sorted { $0.isCorrect != $1.isCorrect && $0.isCorrect == true }
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

		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
		do {
			let data = try encoder.encode(questionBank)
			try data.write(to: fileURL)
		} catch {
			NSLog("error saving: \(error)")
		}
	}

	private func saveCategoryStatistics() {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(allTimeCategoryStatistics)
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
			allTimeCategoryStatistics = stats
		} catch {
			NSLog("Statistics loading failed: \(error)")
		}
	}
}
