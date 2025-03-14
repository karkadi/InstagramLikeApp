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
