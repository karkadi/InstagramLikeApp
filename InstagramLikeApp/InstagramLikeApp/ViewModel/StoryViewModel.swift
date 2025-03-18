//
//  StoryViewModel.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import Foundation

class StoryViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var storyStates: [StoryState] = []
    @Published var error: Error? // Added to expose errors to the UI if needed
    private let repository: StoryRepository
    
    init(repository: StoryRepository = LocalStoryRepository()) {
        self.repository = repository
        Task { await loadInitialData() }
    }
    
    @MainActor
    func loadInitialData() async {
        do {
            let fetchedUsers = try await repository.fetchStories()
            users = fetchedUsers
            
            let savedStates = repository.fetchStoryStates()
            storyStates = savedStates.isEmpty ?
            fetchedUsers.map { StoryState(id: $0.id, isSeen: false, isLiked: false) } :
            savedStates
            
            error = nil // Clear any previous errors on success
        } catch {
            self.error = error
            // Fallback to empty array or cached data if available
            users = []
            storyStates = repository.fetchStoryStates()
            // Log the error or handle it appropriately
            print("Failed to load stories: \(error.localizedDescription)")
        }
    }
    
    func refreshData() async {
        await loadInitialData()
    }
    
    func markStoryAsSeen(userId: Int) {
        updateState(userId: userId, isSeen: true)
    }
    
    func toggleLike(userId: Int) {
        if let state = getStoryState(for: userId) {
            updateState(userId: userId, isLiked: !state.isLiked)
        }
    }
    
    func getStoryState(for userId: Int) -> StoryState? {
        storyStates.first { $0.id == userId }
    }
    
    private func updateState(userId: Int, isSeen: Bool? = nil, isLiked: Bool? = nil) {
        if let index = storyStates.firstIndex(where: { $0.id == userId }) {
            var state = storyStates[index]
            if let seen = isSeen { state.isSeen = seen }
            if let liked = isLiked { state.isLiked = liked }
            storyStates[index] = state
            repository.saveStoryStates(storyStates)
        }
    }
    
    @MainActor
    func loadMoreStories() async {
        let newUsers = users.prefix(30).map { user in
            User(id: users.count + user.id, name: user.name, profilePictureUrl: user.profilePictureUrl)
        }
        users.append(contentsOf: newUsers)
        let newStates = newUsers.map { user in
            StoryState(id: user.id, isSeen: false, isLiked: false)
        }
        storyStates.append(contentsOf: newStates)
        repository.saveStoryStates(storyStates)
    }
}
