//
//  SwiftCodeTextView.swift
//  Swquizft
//
//  Created by Michael Redig on 8/1/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif
import Sourceful

class SwiftCodeTextView: SyntaxTextView {

	var isEditable: Bool {
		get {
			return contentTextView.isEditable
		}
		set {
			contentTextView.isEditable = newValue
		}
	}

	private let swiftLexer = SwiftLexer()
	var heightConstraint: NSLayoutConstraint?

	override func awakeFromNib() {
		super.awakeFromNib()
		theme = DefaultSourceCodeTheme()
		isEditable = false
		delegate = self
	}
}

extension SwiftCodeTextView: SyntaxTextViewDelegate {
	func lexerForSource(_ source: String) -> Lexer {
		return swiftLexer
	}
}
