//
//  StoryGridView.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import SwiftUI

struct StoryGridView: View {
    @StateObject private var viewModel = StoryViewModel()
    @State private var isLoadingMore = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let error = viewModel.error {
                    VStack {
                        Text("Error loading stories")
                            .foregroundColor(.red)
                        Text(error.localizedDescription)
                            .font(.caption)
                        Button("Retry") {
                            Task { await viewModel.refreshData() }
                        }
                        .padding()
                    }
                } else {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.users) { user in
                            StoryPreview(viewModel: viewModel, user: user,
                                         isSeen: viewModel.getStoryState(for: user.id)?.isSeen ?? false
                            )
                            .onAppear {
                                if user.id == viewModel.users.last?.id {
                                    Task { await loadMoreStories() }
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
            }
            .navigationTitle("Stories")
            .refreshable {
                Task { await viewModel.refreshData() }
            }
        }
    }
    
    private func loadMoreStories() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        await viewModel.loadMoreStories()
        isLoadingMore = false
    }
}

#Preview {
    StoryGridView()
}
