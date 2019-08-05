//
//  AnswerView.swift
//  QuestionGenerator
//
//  Created by Michael Redig on 8/5/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

class CreateAnswerView: NSView {
	@IBOutlet var contentView: NSView!
	@IBOutlet var answerView: NSTextView!
	@IBOutlet var reasonView: NSTextView!
	@IBOutlet var isCorrectButton: NSButton!

	var answer: Answer {
		get {
			return createAnswerFromFields()
		}
		set {
			setAnswerFields(answerText: newValue.answerText, reasonText: newValue.reason, isCorrect: newValue.isCorrect)
		}
	}

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		commonInit()
	}

	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
		commonInit()
	}

	private func commonInit() {
		let nib = NSNib(nibNamed: "CreateAnswerView", bundle: nil)
		nib?.instantiate(withOwner: self, topLevelObjects: nil)
		contentView.frame = bounds
		addSubview(contentView)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}

	private func createAnswerFromFields() -> Answer {
		let answerText = answerView.string
		let reasonText = reasonView.string.isEmpty ? nil : reasonView.string
		let isCorrect = isCorrectButton.state == .on
		return Answer(answerText: answerText, isCorrect: isCorrect, reason: reasonText)
	}

	private func setAnswerFields(answerText: String, reasonText: String?, isCorrect: Bool) {
		answerView.string = answerText
		reasonView.string = reasonText ?? ""
		isCorrectButton.state = isCorrect ? .on : .off
	}
}
