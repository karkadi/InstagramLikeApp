# InstagramLikeApp

A SwiftUI-based iOS application implementing an Instagram Stories-like feature with zoom animations.

## Overview

Swift Stories is a demo application that showcases a stories feature similar to Instagram, built with Swift and SwiftUI. It includes a grid view of user stories and zoom transitions to full-screen story views.

## Features

- **Story Grid View**: Displays user stories in a two-column vertical grid using `LazyVGrid`
- **Zoom Animation**: Smooth zoom transition from grid to full-screen story view
- **State Persistence**: Tracks seen/unseen and liked/unliked states across app sessions
- **Infinite Scroll**: Simulates infinite scrolling by duplicating content
- **Pull-to-Refresh**: Refresh the story list with a pull gesture

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+

## Installation

1. Clone the repository:

```bash
git clone https://github.com/karkadi/InstagramLikeApp.git
```

2. Open StoriesApp.xcodeproj in Xcode
3. Ensure the users.json file is added to the project 
4. Build and run the project on a simulator or device

## Usage
1. Launch the app to see the story grid
2. Tap a story to zoom into the full-screen view
3. Tap the heart button to like/unlike a story
4. Tap the close button to return to the grid
5. Pull down on the grid to refresh the data

## Technical Details
- Architecture: MVVM-like pattern with StoryViewModel
- UI Framework: SwiftUI
- Animations: Spring-based zoom transitions
- Persistence: UserDefaults for story states
- Testing: Unit tests for StoryViewModel

## Known Limitations
- Images must be accessible via HTTPS URLs
- No error handling for failed image loads
- Limited to the users in the JSON file

## License
This project is licensed under the MIT License.

## Acknowledgments
Built with ❤️ by Arkadiy KAZAZYAN
Inspired by Instagram Stories
