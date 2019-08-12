//
//  ViewController.swift
//  QuestionGenerator
//
//  Created by Michael Redig on 8/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	@IBOutlet var statisticsHeaderLabel: NSTextField!
	@IBOutlet var questionTableView: NSTableView!
	@IBOutlet var questionTextView: SwiftCodeTextView!

	@IBOutlet var answerStackView: NSStackView!
	@IBOutlet var answerScrollView: NSScrollView!

	@IBOutlet var difficultySegments: NSSegmentedControl!
	@IBOutlet var categoriesCollectionView: NSCollectionView!
	
	@IBOutlet var editExistingButton: NSButton!
	@IBOutlet var createNewButton: NSButton!

	// MARK: - tableColumns
	@IBOutlet var questionColumn: NSTableColumn!
	@IBOutlet var answer1Column: NSTableColumn!
	@IBOutlet var reason1Column: NSTableColumn!
	@IBOutlet var answer2Column: NSTableColumn!
	@IBOutlet var reason2Column: NSTableColumn!
	@IBOutlet var answer3Column: NSTableColumn!
	@IBOutlet var reason3Column: NSTableColumn!
	@IBOutlet var answer4Column: NSTableColumn!
	@IBOutlet var reason4Column: NSTableColumn!
	@IBOutlet var difficultyColumn: NSTableColumn!
	@IBOutlet var categoriesColumn: NSTableColumn!


	let questionController = QuestionController()
	var collectionController: CategoriesCollectionController?
	private let testLabel = NSTextField(labelWithString: "")

	var tableSelectionChangeNotification: NSObjectProtocol?

	override func viewDidLoad() {
		super.viewDidLoad()

		setupStackScrollView()

		questionTextView.isEditable = true

		questionTableView.delegate = self
		questionTableView.dataSource = self
		labelHeaders()
		categoriesCollectionView.register(CategoriesCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier("CategoriesCell"))
		collectionController = CategoriesCollectionController(questionController: questionController, collectionView: categoriesCollectionView)
		categoriesCollectionView.dataSource = collectionController
		categoriesCollectionView.delegate = collectionController

		tableSelectionChangeNotification = NotificationCenter.default.addObserver(forName: NSTableView.selectionDidChangeNotification, object: nil, queue: nil, using: {[weak self] _ in
			self?.selectedQuestionChanged()
		})
		updateViews()
	}

	deinit {
		tableSelectionChangeNotification = nil
	}

	private func setupStackScrollView() {
		answerScrollView.contentView.addSubview(answerStackView)
		answerStackView.translatesAutoresizingMaskIntoConstraints = false
		answerStackView.leadingAnchor.constraint(equalTo: answerScrollView.contentView.leadingAnchor).isActive = true
		answerStackView.trailingAnchor.constraint(equalTo: answerScrollView.contentView.trailingAnchor).isActive = true
		answerStackView.topAnchor.constraint(equalTo: answerScrollView.contentView.topAnchor).isActive = true
		let bottomAnchor = answerStackView.bottomAnchor.constraint(equalTo: answerScrollView.contentView.bottomAnchor)
		bottomAnchor.priority = .defaultHigh
		bottomAnchor.isActive = true
		answerStackView.widthAnchor.constraint(equalTo: answerScrollView.contentView.widthAnchor).isActive = true
	}

	private func labelHeaders() {
		questionColumn.title = "Question"
		answer1Column.title = "Answer 1"
		answer2Column.title = "Answer 2"
		answer3Column.title = "Answer 3"
		answer4Column.title = "Answer 4"
		difficultyColumn.title = "Difficulty"
		categoriesColumn.title = "Categories"
	}

	func openFile() {
		let openPanel = NSOpenPanel()
		openPanel.canChooseDirectories = false
		openPanel.canChooseFiles = true
		openPanel.allowedFileTypes = ["swquiz"]

		openPanel.begin { response in
			if response == .OK {
				guard let fileURL = openPanel.url else { return }

				self.questionController.questionBankURL = fileURL
				self.questionTableView.reloadData()
				self.updateViews()
			}
		}
	}

	func saveFile() {
		if questionController.questionBankURL == nil {
			let savePanel = NSSavePanel()
			savePanel.allowedFileTypes = ["swquiz"]
			savePanel.isExtensionHidden = false

			savePanel.begin { response in
				if response == .OK {
					guard let fileURL = savePanel.url else { return }

					if FileManager.default.fileExists(atPath: fileURL.path) {
						print("should probably delete...")
					}
					self.questionController.questionBankURL = fileURL
					self.questionController.saveToPersistence()
				}
			}
		} else {
			questionController.saveToPersistence()
		}
	}
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
	func numberOfRows(in tableView: NSTableView) -> Int {
		return questionController.questionBank.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let column = tableColumn else { return nil }
		let question = questionController.questionBank[row]

		var text = ""
		let answerCount = question.answers.count
		var textColor = NSColor.white
		var highlightSyntax = false

		switch column {
		case questionColumn:
			text = question.prompt
			highlightSyntax = true
		case answer1Column:
			guard answerCount >= 1 else { break }
			text = question.answers[0].answerText
			textColor = question.answers[0].isCorrect ? .green : .red
		case reason1Column:
			guard answerCount >= 1 else { break }
			text = question.answers[0].reason ?? ""
			highlightSyntax = true
		case answer2Column:
			guard answerCount >= 2 else { break }
			text = question.answers[1].answerText
			textColor = question.answers[1].isCorrect ? .green : .red
		case reason2Column:
			guard answerCount >= 2 else { break }
			text = question.answers[1].reason ?? ""
			highlightSyntax = true
		case answer3Column:
			guard answerCount >= 3 else { break }
			text = question.answers[2].answerText
			textColor = question.answers[2].isCorrect ? .green : .red
		case reason3Column:
			guard answerCount >= 3 else { break }
			text = question.answers[2].reason ?? ""
			highlightSyntax = true
		case answer4Column:
			guard answerCount >= 4 else { break }
			text = question.answers[3].answerText
			textColor = question.answers[3].isCorrect ? .green : .red
		case reason4Column:
			guard answerCount >= 4 else { break }
			text = question.answers[3].reason ?? ""
			highlightSyntax = true
		case difficultyColumn:
			text = question.difficulty.stringValue
		case categoriesColumn:
			text = question.categoryTags.map { $0.rawValue }.joined(separator: " ")
		default:
			text = ""
		}

		let cell: NSTableCellView?
		if highlightSyntax {
			let swiftCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("SwiftView"), owner: self) as? SwiftTableCellView
			swiftCell?.swiftCodeView.text = text
			swiftCell?.swiftCodeView.theme = SmallerTheme()
			cell = swiftCell
		} else {
			cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("LabelView"), owner: self) as? NSTableCellView
			cell?.textField?.stringValue = text
			cell?.textField?.textColor = textColor
		}

		return cell
	}

	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		var minSize: CGFloat = 30
		let question = questionController.questionBank[row]
		let items = [question.prompt] + question.answers.map { $0.answerText } + question.answers.compactMap { $0.reason }
		for test in items {
			testLabel.stringValue = test
			minSize = max(testLabel.fittingSize.height, minSize)
		}
		return minSize
	}
}

// MARK: - view setup stuff
extension ViewController {
	private func clearQuestionFields() {
		clearAnswers()
		questionTextView.text = ""
		difficultySegments.selectedSegment = -1
	}

	private func clearAnswers() {
		for answerView in answerStackView.arrangedSubviews {
			answerView.removeFromSuperview()
		}
	}

	private func addAnswerToStack(_ answer: Answer) {
		let answerView = CreateAnswerView(frame: CGRect(origin: .zero, size: NSSize(width: view.frame.size.width, height: 20)))
		answerView.answer = answer
		answerView.layer = CALayer()
		answerStackView.addArrangedSubview(answerView)
	}

	func selectedQuestionChanged() {
		updateViews()
	}

	private func updateViews() {
		clearQuestionFields()
		let selection = questionTableView.selectedRow
		switch selection {
		case 0..<questionController.questionBank.count:
			let question = questionController.questionBank[selection]
			collectionController?.selectedQuestion = selection
			questionTextView.text = question.prompt
			difficultySegments.selectedSegment = question.difficulty.rawValue
			for answer in question.answers {
				addAnswerToStack(answer)
			}
		default:
			collectionController?.selectedQuestion = nil
			let dummyAnswer = Answer(answerText: "", isCorrect: false, reason: nil)
			for _ in 1...4 {
				addAnswerToStack(dummyAnswer)
			}
		}
		statisticsHeaderLabel.stringValue = generateStatistics()
	}

	private func generateStatistics() -> String {
		var catStats = ["Total: \(questionController.questionBank.count)"]
		for cat in Question.Category.allCases {
			let count = questionController.questionBank.filter { $0.categoryTags.contains(cat) }
			let value = "\(cat.rawValue.capitalized): \(count.count)"
			catStats.append(value)
		}

		return catStats.joined(separator: " | ")
	}
}

// MARK: - IBActions {
extension ViewController {
	@IBAction func openMenuItemPressed(_ sender: NSMenuItem) {
		openFile()
	}

	@IBAction func saveMenuItemPressed(_ sender: NSMenuItem) {
		saveFile()
	}

	func gatherQuestionParts() -> (prompt: String, answers: [Answer], categoryTags: Set<Question.Category>, difficulty: Question.Difficulty)? {
		let prompt = questionTextView.text
		guard !prompt.isEmpty,
			let difficulty = Question.Difficulty(rawValue: difficultySegments.selectedSegment) else { return nil }

		var answers = [Answer]()
		for view in answerStackView.arrangedSubviews {
			if let answerView = view as? CreateAnswerView, let answer = answerView.answer {
				answers.append(answer)
			}
		}

		let categoryTags = questionController.selectedCategories
		return (prompt, answers, categoryTags, difficulty)
	}

	@IBAction func createNewQuestionPressed(_ sender: NSButton) {
		guard let parts = gatherQuestionParts() else { return }

		questionController.createQuestionWith(prompt: parts.prompt, answers: parts.answers, categoryTags: parts.categoryTags, difficulty: parts.difficulty)
		questionTableView.reloadData()
		updateViews()
	}

	@IBAction func updateQuestionPressed(_ sender: NSButton) {
		guard let parts = gatherQuestionParts() else { return }

		let selectedItem = questionTableView.selectedRow
		guard (0..<questionController.questionBank.count).contains(selectedItem) else { return }
		let oldQuestion = questionController.questionBank[selectedItem]
		questionController.update(question: oldQuestion, withPrompt: parts.prompt, answers: parts.answers, categoryTags: parts.categoryTags, difficulty: parts.difficulty)
		questionTableView.reloadData()
		updateViews()
	}

	@IBAction func deselectQuestion(_ sender: NSMenuItem) {
		questionTableView.deselectRow(questionTableView.selectedRow)
		updateViews()
	}
}
