//
//  StoryState.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import Foundation

struct StoryState: Identifiable, Codable {
    let id: Int
    var isSeen: Bool
    var isLiked: Bool
}
