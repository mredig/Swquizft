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
	@IBOutlet private(set) var reasonLabel: UILabel!

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
		reasonLabel.isHidden = true
	}

	private func updateViews() {
		stackTopConstraint.constant = edgeInsets.top
		stackBottomConstraint.constant = edgeInsets.bottom
		stackLeadingConstraint.constant = edgeInsets.left
		stackTrailingConstraint.constant = edgeInsets.right

		guard let answer = answer else { return }
		answerLabel.attributedText = CodeFormatHelper.convertFromMarkdown(answer.answerText)
		let correctnessString = answer.isCorrect ? "Yep!" : "Nope 🥺"
		let reasonString: String
		if let reason = answer.reason {
			reasonString = ": \(reason)"
		} else {
			reasonString = ""
		}
		reasonLabel.attributedText = CodeFormatHelper.convertFromMarkdown("***\(correctnessString)***\(reasonString)")
	}

	@IBAction func answerViewTapped(_ sender: UITapGestureRecognizer) {
		print("tapped \(answerLabel.text) \(reasonLabel.text)")
		UIView.animate(withDuration: 0.2) {
			self.reasonLabel.isHidden.toggle()
			self.stackView.layoutSubviews()
		}
	}

}
