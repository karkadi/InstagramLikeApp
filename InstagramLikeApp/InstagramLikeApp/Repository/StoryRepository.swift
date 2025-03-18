//
//  StoryRepository.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 18/03/2025.
//
import Foundation

protocol StoryRepository {
    func fetchStories() async throws -> [User]
    func fetchStoryStates() -> [StoryState]
    func saveStoryStates(_ states: [StoryState])
}

class LocalStoryRepository: StoryRepository {
    private let dataSourceURL: URL?
    private let userDefaults: UserDefaults
    
    init(dataSourceURL: URL? = Bundle.main.url(forResource: "users", withExtension: "json"),
         userDefaults: UserDefaults = .standard) {
        self.dataSourceURL = dataSourceURL
        self.userDefaults = userDefaults
    }
    
    func fetchStories() async throws -> [User] {
        guard let url = dataSourceURL,
              let data = try? Data(contentsOf: url),
              let storyData = try? JSONDecoder().decode(StoryData.self, from: data) else {
            return []
        }
        return storyData.pages.flatMap { $0.users }
    }
    
    func fetchStoryStates() -> [StoryState] {
        guard let savedStates = userDefaults.data(forKey: "storyStates"),
              let decodedStates = try? JSONDecoder().decode([StoryState].self, from: savedStates) else {
            return []
        }
        return decodedStates
    }
    
    func saveStoryStates(_ states: [StoryState]) {
        if let encoded = try? JSONEncoder().encode(states) {
            userDefaults.set(encoded, forKey: "storyStates")
        }
    }
}
