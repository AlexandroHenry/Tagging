//
//  Tag.swift
//  Tagging
//
//  Created by Seungchul Ha on 2023/02/28.
//

import SwiftUI

struct Tag: Identifiable, Hashable {
	var id = UUID().uuidString
	var text: String
	var size: CGFloat = 0
}
