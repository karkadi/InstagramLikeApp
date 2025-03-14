//
//  StoryListView.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//


// StoryListView.swift
import SwiftUI

struct StoryListView: View {
    @StateObject private var viewModel = StoryViewModel()
    @State private var isLoadingMore = false
    
    // Define grid layout: 2 columns with flexible sizing
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.users) { user in
                        StoryPreview(user: user,
                                     isSeen: viewModel.getStoryState(for: user.id)?.isSeen ?? false
                        )
                        .onAppear {
                            if user.id == viewModel.users.last?.id {
                                // For test purposes , giving errors due to same user ID
                                //  loadMoreStories()
                            }
                        }
                    }
                    
                    if isLoadingMore {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Stories")
            .refreshable {
                viewModel.loadData()
                viewModel.loadStates()
            }
        }
    }
    
    private func loadMoreStories() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            viewModel.simulateInfiniteScroll()
            isLoadingMore = false
        }
    }
}


#Preview {
    StoryListView()
}

