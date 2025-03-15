//
//  StoryViewModelTests.swift
//  StoryViewModelTests
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import XCTest
@testable import InstagramLikeApp

class StoryViewModelTests: XCTestCase {
    
    var viewModel: StoryViewModel!
    var mockURL: URL!
    
    override func setUp() {
        super.setUp()
        
        // Create a temporary mock JSON file
        let mockJSON = """
        {
            "pages": [
                {
                    "users": [
                        {"id": 1, "name": "Neo", "profile_picture_url": "https://example.com/1"},
                        {"id": 2, "name": "Trinity", "profile_picture_url": "https://example.com/2"}
                    ]
                }
            ]
        }
        """
        
        let tempDir = FileManager.default.temporaryDirectory
        mockURL = tempDir.appendingPathComponent("mock_users.json")
        try? mockJSON.write(to: mockURL, atomically: true, encoding: .utf8)
        
        // Clear UserDefaults before each test
        UserDefaults.standard.removeObject(forKey: "storyStates")
        
        viewModel = StoryViewModel(dataSourceURL: mockURL)
    }
    
    override func tearDown() {
        // Clean up
        try? FileManager.default.removeItem(at: mockURL)
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialDataLoading() {
        // Given
        let expectedUserCount = 2
        
        // When (setup already loaded data)
        
        // Then
        XCTAssertEqual(viewModel.users.count, expectedUserCount)
        XCTAssertEqual(viewModel.users[0].name, "Neo")
        XCTAssertEqual(viewModel.users[1].name, "Trinity")
    }
    
    func testInitialStoryStates() {
        // Given
        let expectedStateCount = 2
        
        // When (setup already loaded states)
        
        // Then
        XCTAssertEqual(viewModel.storyStates.count, expectedStateCount)
        XCTAssertFalse(viewModel.storyStates[0].isSeen)
        XCTAssertFalse(viewModel.storyStates[0].isLiked)
    }
    
    func testMarkStoryAsSeen() {
        // Given
        let userId = 1
        
        // When
        viewModel.markStoryAsSeen(userId: userId)
        
        // Then
        let state = viewModel.getStoryState(for: userId)
        XCTAssertNotNil(state)
        XCTAssertTrue(state!.isSeen)
        XCTAssertFalse(state!.isLiked)
    }
    
    func testToggleLike() {
        // Given
        let userId = 1
        let initialState = viewModel.getStoryState(for: userId)!
        
        // When
        viewModel.toggleLike(userId: userId)
        
        // Then
        let updatedState = viewModel.getStoryState(for: userId)!
        XCTAssertFalse(initialState.isLiked)
        XCTAssertTrue(updatedState.isLiked)
        
        // When (toggle again)
        viewModel.toggleLike(userId: userId)
        
        // Then
        let finalState = viewModel.getStoryState(for: userId)!
        XCTAssertFalse(finalState.isLiked)
    }
    
    func testStatePersistence() {
        // Given
        let userId = 1
        
        // When
        viewModel.markStoryAsSeen(userId: userId)
        viewModel.toggleLike(userId: userId)
        
        // Create new instance to simulate app restart
        let newViewModel = StoryViewModel(dataSourceURL: mockURL)
        
        // Then
        let state = newViewModel.getStoryState(for: userId)!
        XCTAssertTrue(state.isSeen)
        XCTAssertTrue(state.isLiked)
    }
    
    func testSimulateInfiniteScroll() {
        // Given
        let initialCount = viewModel.users.count
        
        // When
        viewModel.simulateInfiniteScroll()
        
        // Then
        XCTAssertEqual(viewModel.users.count, initialCount * 2)
        XCTAssertEqual(viewModel.users[viewModel.users.count - 1].id, initialCount * 2)
    }
    
    func testInvalidDataSource() {
        // Given
        let invalidURL = FileManager.default.temporaryDirectory.appendingPathComponent("nonexistent.json")
        
        // When
        let invalidViewModel = StoryViewModel(dataSourceURL: invalidURL)
        
        // Then
        XCTAssertTrue(invalidViewModel.users.isEmpty)
        XCTAssertTrue(invalidViewModel.storyStates.isEmpty)
    }
}
