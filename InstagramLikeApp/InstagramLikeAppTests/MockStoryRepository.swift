//
//  MockStoryRepository.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 18/03/2025.
//

import XCTest
@testable import InstagramLikeApp // Replace with your actual module name

// Mock repository for testing
class MockStoryRepository: StoryRepository {
    var shouldReturnError = false
    var savedStates: [StoryState] = []
    var mockUsers: [User] = [
        User(id: 1, name: "User1", profilePictureUrl: "url1"),
        User(id: 2, name: "User2", profilePictureUrl: "url2")
    ]
    
    func fetchStories() async throws -> [User] {
        if shouldReturnError {
            throw NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return mockUsers
    }
    
    func fetchStoryStates() -> [StoryState] {
        return savedStates
    }
    
    func saveStoryStates(_ states: [StoryState]) {
        savedStates = states
    }
}
