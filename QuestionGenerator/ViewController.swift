//
//  ViewController.swift
//  QuestionGenerator
//
//  Created by Michael Redig on 8/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	@IBOutlet var questionTableView: NSTableView!
	@IBOutlet var questionTextView: NSTextView!

	@IBOutlet var answerStackView: NSStackView!
	@IBOutlet var answerScrollView: NSScrollView!

	@IBOutlet var difficultySegments: NSSegmentedControl!
	@IBOutlet var categoriesTextField: NSTextField!

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
	private let testLabel = NSTextField(labelWithString: "")

	var tableSelectionChangeNotification: NSObjectProtocol?

	override func viewDidLoad() {
		super.viewDidLoad()

		setupStackScrollView()

		questionTableView.delegate = self
		questionTableView.dataSource = self
		labelHeaders()

		tableSelectionChangeNotification = NotificationCenter.default.addObserver(forName: NSTableView.selectionDidChangeNotification, object: nil, queue: nil, using: { _ in
			self.updateViews()
		})
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
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
	func numberOfRows(in tableView: NSTableView) -> Int {
		return questionController.questionBank.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("LabelView"), owner: self) as? NSTableCellView
		guard let column = tableColumn else { return nil }
		let question = questionController.questionBank[row]

		var text = ""
		let answerCount = question.answers.count
		var textColor = NSColor.white

		switch column {
		case questionColumn:
			text = question.prompt
		case answer1Column:
			guard answerCount >= 1 else { break }
			text = question.answers[0].answerText
			textColor = question.answers[0].isCorrect ? .green : .red
		case reason1Column:
			guard answerCount >= 1 else { break }
			text = question.answers[0].reason ?? ""
		case answer2Column:
			guard answerCount >= 2 else { break }
			text = question.answers[1].answerText
			textColor = question.answers[1].isCorrect ? .green : .red
		case reason2Column:
			guard answerCount >= 2 else { break }
			text = question.answers[1].reason ?? ""
		case answer3Column:
			guard answerCount >= 3 else { break }
			text = question.answers[2].answerText
			textColor = question.answers[2].isCorrect ? .green : .red
		case reason3Column:
			guard answerCount >= 3 else { break }
			text = question.answers[2].reason ?? ""
		case answer4Column:
			guard answerCount >= 4 else { break }
			text = question.answers[3].answerText
			textColor = question.answers[3].isCorrect ? .green : .red
		case reason4Column:
			guard answerCount >= 4 else { break }
			text = question.answers[3].reason ?? ""
		case difficultyColumn:
			text = question.difficulty.stringValue
		case categoriesColumn:
			text = question.categoryTags.map { $0.rawValue }.joined(separator: " ")
		default:
			text = ""
		}

		cell?.textField?.stringValue = text
		cell?.textField?.textColor = textColor

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

	func updateViews() {
		clearAnswers()
		let selection = questionTableView.selectedRow
		switch selection {
		case 0..<questionController.questionBank.count:
			clearAnswers()
			print("selected \(selection)")
			let question = questionController.questionBank[selection]
			for answer in question.answers {
				addAnswerToStack(answer)
			}
		default:
			print("deselected")
		}
	}
}
