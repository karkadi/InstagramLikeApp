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
    var mockRepository: MockStoryRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockStoryRepository()
        viewModel = StoryViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testInitialLoadSuccess() async {
        // Given
        mockRepository.shouldReturnError = false
        
        // When
        await viewModel.loadInitialData()
        
        // Then
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.storyStates.count, 2)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.users[0].name, "User1")
        XCTAssertFalse(viewModel.storyStates[0].isSeen)
        XCTAssertFalse(viewModel.storyStates[0].isLiked)
    }
    
    func testInitialLoadFailure() async {
        // Given
        mockRepository.shouldReturnError = true
        
        // When
        await viewModel.loadInitialData()
        
        // Then
        XCTAssertEqual(viewModel.users.count, 0)
        XCTAssertNotNil(viewModel.error)
        XCTAssertEqual(viewModel.storyStates.count, 0)
    }
    
    func testMarkStoryAsSeen() async {
        // Given
        await viewModel.loadInitialData()
        let userId = 1
        
        // When
        viewModel.markStoryAsSeen(userId: userId)
        
        // Then
        let state = viewModel.getStoryState(for: userId)
        XCTAssertNotNil(state)
        XCTAssertTrue(state!.isSeen)
        XCTAssertEqual(mockRepository.savedStates.first(where: { $0.id == userId })?.isSeen, true)
    }
    
    func testToggleLike() async {
        // Given
        await viewModel.loadInitialData()
        let userId = 1
        let initialState = viewModel.getStoryState(for: userId)!
        
        // When
        viewModel.toggleLike(userId: userId)
        
        // Then
        let state = viewModel.getStoryState(for: userId)
        XCTAssertNotNil(state)
        XCTAssertEqual(state!.isLiked, !initialState.isLiked)
        XCTAssertEqual(mockRepository.savedStates.first(where: { $0.id == userId })?.isLiked, true)
        
        // Toggle back
        viewModel.toggleLike(userId: userId)
        XCTAssertFalse(viewModel.getStoryState(for: userId)!.isLiked)
    }
    
    func testLoadMoreStories() async {
        // Given
        await viewModel.loadInitialData()
        let initialCount = viewModel.users.count
        
        // When
        await viewModel.loadMoreStories()
        
        // Then
        XCTAssertEqual(viewModel.users.count, initialCount + 2) // 2 from mock, 2 more added
        XCTAssertEqual(viewModel.storyStates.count, initialCount + 2)
        XCTAssertEqual(mockRepository.savedStates.count, initialCount + 2)
        // Verify new states are initialized correctly
        let newState = viewModel.storyStates.last!
        XCTAssertFalse(newState.isSeen)
        XCTAssertFalse(newState.isLiked)
    }
    
    func testGetStoryState() async {
        // Given
        await viewModel.loadInitialData()
        let userId = 1
        
        // When
        let state = viewModel.getStoryState(for: userId)
        
        // Then
        XCTAssertNotNil(state)
        XCTAssertEqual(state!.id, userId)
    }
    
    func testRefreshData() async {
        // Given
        await viewModel.loadInitialData()
        mockRepository.mockUsers.append(User(id: 3, name: "User3", profilePictureUrl: "url3"))
        
        // When
        await viewModel.refreshData()
        
        // Then
        XCTAssertEqual(viewModel.users.count, 3)
        XCTAssertEqual(viewModel.storyStates.count, 3)
    }
}
