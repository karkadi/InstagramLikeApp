//
//  StoryPreview.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import SwiftUI

struct StoryPreview: View {
    let viewModel: StoryViewModel
    let user: User
    let isSeen: Bool
    
    var body: some View {
        NavigationLink(destination: StoryView(viewModel: viewModel, user: user)) {
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: user.profilePictureUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSeen ? Color.gray : Color.blue, lineWidth: 2)
                )
                
                Text(user.name)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
    }
}
