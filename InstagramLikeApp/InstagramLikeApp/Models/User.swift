//
//  User.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import Foundation

struct User: Identifiable, Codable {
    var id: Int
    let name: String
    let profilePictureUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePictureUrl = "profile_picture_url"
    }
}
