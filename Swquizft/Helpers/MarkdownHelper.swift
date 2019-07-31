//
//  MarkdownHelper.swift
//  Swquizft
//
//  Created by Michael Redig on 7/31/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import Down

enum MarkdownHelper {
	static func convertFromMarkdown(_ markdownString: String) -> NSAttributedString {
		let down = Down(markdownString: markdownString)

		return (try? down.toAttributedString()) ?? NSAttributedString(string: "")
	}
}


