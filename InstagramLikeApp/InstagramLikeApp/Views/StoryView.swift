//
//  StoryView.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import SwiftUI

struct StoryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = StoryViewModel()
    @State private var isAnimating = false
    let user: User
   
    private var storyState: StoryState? {
        viewModel.storyStates.first(where: { $0.id == user.id })
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.profilePictureUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            //.ignoresSafeArea()
            .frame(maxWidth: isAnimating ? .infinity : 100, maxHeight: isAnimating ? .infinity : 100)
            .clipped()
            .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: isAnimating)
        }
        .gesture(DragGesture()
            .onEnded { value in
                if value.translation.width > 50 {
                    dismiss()
                }
            }
        )
        .onAppear {
            withAnimation {
                isAnimating = true
                viewModel.markStoryAsSeen(userId: user.id)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitle(user.name, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("AppTextColor"))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    let currentLiked = storyState?.isLiked ?? false
                    viewModel.updateState(id: user.id, isLiked: !currentLiked)
                }) {
                    Image(systemName: (storyState?.isLiked ?? false) ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                }
            }
        }
        
    }
}
