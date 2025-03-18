//
//  StoryView.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import SwiftUI

struct StoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: StoryViewModel
    let user: User
    
    private var storyState: StoryState? {
        viewModel.getStoryState(for: user.id)
    }
    
    var body: some View {
        AsyncImage(url: URL(string: user.profilePictureUrl)) { image in
            image
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        } placeholder: {
            ProgressView()
        }
        .onAppear {
            viewModel.markStoryAsSeen(userId: user.id)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(user.name)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleLike(userId: user.id)
                }) {
                    Image(systemName: storyState?.isLiked ?? false ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
        }
        .toolbarBackground(.black.opacity(0.5), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let viewModel = StoryViewModel()
    let user = User(id: 1, name: "Neo", profilePictureUrl: "https://i.pravatar.cc/300?u=1")
    NavigationStack {
        StoryView(viewModel: viewModel, user: user )
    }
}
