//
//  AnswerView.swift
//  Swquizft
//
//  Created by Michael Redig on 7/31/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class AnswerView: UIView {
	@IBOutlet var contentView: UIView!
	@IBOutlet private var xibConstraints: [NSLayoutConstraint]!
	@IBOutlet var stackView: UIStackView!
	@IBOutlet private var stackBottomConstraint: NSLayoutConstraint!
	@IBOutlet private var stackTopConstraint: NSLayoutConstraint!
	@IBOutlet private var stackLeadingConstraint: NSLayoutConstraint!
	@IBOutlet private var stackTrailingConstraint: NSLayoutConstraint!
	@IBOutlet private(set) var answerLabel: UILabel!
	@IBOutlet private(set) var correctnessLabel: UILabel!
	@IBOutlet private(set) var reasonView: SwiftCodeTextView!

	var edgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
		didSet {
			updateViews()
		}
	}

	var answer: Answer? {
		didSet {
			updateViews()
		}
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	convenience init(answer: Answer? = nil) {
		self.init(frame: CGRect(origin: .zero, size: .init(width: 414, height: 30)))
		self.answer = answer
		updateViews()
	}

	private func commonInit() {
		let nib = UINib(nibName: "AnswerView", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		contentView.frame = bounds
		addSubview(contentView)
		updateViews()
		reasonView.isHidden = true
		correctnessLabel.isHidden = true
	}

	private func updateViews() {
		stackTopConstraint.constant = edgeInsets.top
		stackBottomConstraint.constant = edgeInsets.bottom
		stackLeadingConstraint.constant = edgeInsets.left
		stackTrailingConstraint.constant = edgeInsets.right

		guard let answer = answer else { return }
		answerLabel.attributedText = CodeFormatHelper.convertFromMarkdown(answer.answerText)
		let correctnessString = answer.isCorrect ? "Yep!" : "Nope 🥺"
		correctnessLabel.text = correctnessString
		correctnessLabel.textColor = answer.isCorrect ? .green : .red
		reasonView.text = answer.reason ?? ""
	}

	@IBAction func answerViewTapped(_ sender: UITapGestureRecognizer) {
		UIView.animate(withDuration: 0.2) {
			self.correctnessLabel.isHidden.toggle()
			self.reasonView.isHidden = self.correctnessLabel.isHidden
			if !self.reasonView.isHidden && !self.reasonView.text.isEmpty {
				self.reasonView.contentTextView.sizeToFit()
				self.reasonView.sizeToFit()
				self.reasonView.heightConstraint = self.reasonView.heightAnchor.constraint(equalToConstant: self.reasonView.contentTextView.frame.size.height)
				self.reasonView.heightConstraint?.isActive = true
			} else {
				self.reasonView.heightConstraint?.isActive = false
				self.reasonView.heightConstraint = nil
			}

			self.stackView.layoutSubviews()
		}
	}

}
