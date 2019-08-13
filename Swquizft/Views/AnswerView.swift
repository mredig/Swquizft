//
//  AnswerView.swift
//  Swquizft
//
//  Created by Michael Redig on 7/31/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

protocol AnswerViewDelegate: AnyObject {
	func answerView(_ answerView: AnswerView, revealedAnswer answer: Answer)
}

class AnswerView: UIView {
	@IBOutlet var contentView: UIView!
	@IBOutlet private var xibConstraints: [NSLayoutConstraint]!
	@IBOutlet var stackView: UIStackView!
	@IBOutlet private var stackBottomConstraint: NSLayoutConstraint!
	@IBOutlet private var stackTopConstraint: NSLayoutConstraint!
	@IBOutlet private var stackLeadingConstraint: NSLayoutConstraint!
	@IBOutlet private var stackTrailingConstraint: NSLayoutConstraint!
	@IBOutlet private(set) var swiftyAnswerView: SwiftCodeTextView!
	@IBOutlet private(set) var correctnessLabel: UILabel!
	@IBOutlet private(set) var reasonView: SwiftCodeTextView!
	private var answerHeight: NSLayoutConstraint?

	weak var delegate: AnswerViewDelegate?
	var isCurrentlyRevealed: Bool {
		return !correctnessLabel.isHidden
	}

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

		answerHeight = swiftyAnswerView.heightAnchor.constraint(equalToConstant: 20.5)
		answerHeight?.isActive = true
		swiftyAnswerView.isUserInteractionEnabled = false

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
		swiftyAnswerView.text = answer.answerText
		answerHeight?.constant = swiftyAnswerView.requiredHeight(for: frame.size.width)
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
				self.reasonView.heightConstraint = self.reasonView.heightAnchor.constraint(equalToConstant: self.reasonView.requiredHeight(for: self.frame.size.width))
				self.reasonView.heightConstraint?.isActive = true
			} else {
				self.reasonView.heightConstraint?.isActive = false
				self.reasonView.heightConstraint = nil
			}
			self.stackView.layoutSubviews()
		}
		guard let answer = answer, !self.correctnessLabel.isHidden else { return }
		delegate?.answerView(self, revealedAnswer: answer)
	}

}
