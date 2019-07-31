//
//  AnswerTableViewCell.swift
//  Swquizft
//
//  Created by Michael Redig on 7/31/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

	@IBOutlet var answerTextView: UITextView!

	var answer: Answer? {
		didSet {
			updateViews()
		}
	}

	private func updateViews() {
		guard let answer = answer else { return }
		answerTextView.attributedText = MarkdownHelper.convertFromMarkdown(answer.answerText)
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
