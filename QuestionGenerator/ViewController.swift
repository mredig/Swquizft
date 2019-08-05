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

	override func viewDidLoad() {
		super.viewDidLoad()

		questionTableView.delegate = self
		questionTableView.dataSource = self
		labelHeaders()
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

		cell?.textField?.stringValue = "test label\n\nand another line"

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
