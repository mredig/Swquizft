//
//  SmallerTheme.swift
//  QuestionGenerator
//
//  Created by Michael Redig on 8/11/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Sourceful

public struct SmallerTheme: SourceCodeTheme {
	private static var lineNumbersColor: Color {
		return Color(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
	}

	public var plainSyntaxColor = Color.white
	public var numberSyntaxColor = Color(red: 116/255, green: 109/255, blue: 176/255, alpha: 1.0)
	public var stringSyntaxColor = Color(red: 211/255, green: 35/255, blue: 46/255, alpha: 1.0)
	public var identifierSyntaxColor = Color(red: 20/255, green: 156/255, blue: 146/255, alpha: 1.0)
	public var keywordSyntaxColor = Color(red: 215/255, green: 0, blue: 143/255, alpha: 1.0)
	public var commentSyntaxColor = Color(red: 69.0/255.0, green: 187.0/255.0, blue: 62.0/255.0, alpha: 1.0)
	public var editorPlaceholderSyntaxColor = Color(red: 31/255.0, green: 32/255, blue: 41/255, alpha: 1.0)

	public func color(for syntaxColorType: SourceCodeTokenType) -> Color {
		switch syntaxColorType {
		case .plain:
			return plainSyntaxColor

		case .number:
			return numberSyntaxColor

		case .string:
			return stringSyntaxColor

		case .identifier:
			return identifierSyntaxColor

		case .keyword:
			return keywordSyntaxColor

		case .comment:
			return commentSyntaxColor

		case .editorPlaceholder:
			return editorPlaceholderSyntaxColor
		}

	}

	public var lineNumbersStyle: LineNumbersStyle? = LineNumbersStyle(font: Font(name: "Menlo", size: 5)!, textColor: lineNumbersColor)
	public var gutterStyle = GutterStyle(backgroundColor: Color(red: 21/255.0, green: 22/255, blue: 31/255, alpha: 1.0), minimumWidth: 0)
	public var font = Font(name: "Menlo", size: 10)!
	public var backgroundColor = Color(red: 31/255.0, green: 32/255, blue: 41/255, alpha: 1.0)
}
