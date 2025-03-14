//
//  DataManager.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import Foundation

class StoryViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var storyStates: [StoryState] = []
    
    private let dataSourceURL: URL?
    
    init(dataSourceURL: URL? = Bundle.main.url(forResource: "users", withExtension: "json")) {
        self.dataSourceURL = dataSourceURL
        loadData()
        loadStates()
    }
    
    func loadData() {
        guard let url = dataSourceURL,
              let data = try? Data(contentsOf: url),
              let storyData = try? JSONDecoder().decode(StoryData.self, from: data) else {
            return
        }
        users = storyData.pages.flatMap { $0.users }
    }
    
    func loadStates() {
        if let savedStates = UserDefaults.standard.data(forKey: "storyStates"),
           let decodedStates = try? JSONDecoder().decode([StoryState].self, from: savedStates) {
            storyStates = decodedStates
        } else {
            storyStates = users.map { StoryState(id: $0.id, isSeen: false, isLiked: false) }
        }
    }
    
    func saveStates() {
        if let encoded = try? JSONEncoder().encode(storyStates) {
            UserDefaults.standard.set(encoded, forKey: "storyStates")
        }
    }
    
    func markStoryAsSeen(userId: Int) {
        updateState(id: userId, isSeen: true)
    }
    
    func toggleLike(userId: Int) {
        if let index = storyStates.firstIndex(where: { $0.id == userId }) {
            let currentLiked = storyStates[index].isLiked
            updateState(id: userId, isLiked: !currentLiked)
        }
    }
    
    func getStoryState(for userId: Int) -> StoryState? {
        storyStates.first(where: { $0.id == userId })
    }
    
    func updateState(id: Int, isSeen: Bool? = nil, isLiked: Bool? = nil) {
        if let index = storyStates.firstIndex(where: { $0.id == id }) {
            if let seen = isSeen {
                storyStates[index].isSeen = seen
            }
            if let liked = isLiked {
                storyStates[index].isLiked = liked
            }
            saveStates()
        }
    }
    
    func simulateInfiniteScroll() {
        users.append(contentsOf: users)
    }
}
