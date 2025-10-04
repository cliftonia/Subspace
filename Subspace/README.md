# Square Enix iOS App

A modern iOS application built with SwiftUI following senior iOS developer best practices and clean architecture principles.

## 🏗️ Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture with clean separation of concerns:

- **Models**: Immutable value types with type-safe identifiers
- **Views**: Pure SwiftUI views with no business logic
- **ViewModels**: `@MainActor` classes managing UI state and user interactions
- **Services**: Protocol-based services handling data operations

## 📁 Project Structure

```
Subspace/
├── App/
│   ├── App.swift                    # Main app entry point
│   ├── AppRootView.swift           # Root navigation container
│   ├── AppRoute.swift              # Type-safe routing system
│   └── AppDependencies.swift       # Dependency injection container
├── Core/
│   ├── Extensions/
│   │   └── LoggerExtensions.swift  # Structured logging utilities
│   ├── Models/
│   │   └── User.swift              # Core domain models
│   └── Networking/
│       └── NetworkError.swift      # Typed error handling
├── Features/
│   ├── Home/
│   │   ├── Views/
│   │   │   └── HomeView.swift      # Home screen UI
│   │   ├── ViewModels/
│   │   │   └── HomeViewModel.swift # Home screen logic
│   │   └── Services/
│   │       └── MessageService.swift # Welcome message service
│   ├── Profile/
│   │   ├── Views/
│   │   │   └── ProfileView.swift   # Profile screen UI
│   │   └── ViewModels/
│   │       └── ProfileViewModel.swift # Profile screen logic
│   ├── Settings/
│   │   └── Views/
│   │       └── SettingsView.swift  # Settings screen UI
│   └── Shared/
│       └── Services/
│           └── UserService.swift   # User data service
├── Tests/
│   └── SubspaceTests.swift      # Swift Testing test suites
├── Configuration/
│   ├── .swiftlint.yml             # SwiftLint configuration  
│   └── BACKEND_SETUP.md           # Backend integration guide
└── Legacy/ (⚠️ Scheduled for deletion)
    ├── ContentView.swift          # Redirect to new architecture
    ├── ContentViewModel.swift     # Empty placeholder (safe to delete)
    └── SubspaceApp.swift      # Redirect to new architecture
```

## 🎯 Key Features

### ✅ Code Quality Standards
- **Zero SwiftLint Warnings**: Strict linting with custom rules
- **Type Safety**: Tagged types for identifiers, no stringly-typed APIs
- **Structured Logging**: `os.Logger` with categories and levels
- **Error Handling**: Typed errors with `LocalizedError` conformance
- **Async/Await**: Modern Swift concurrency throughout

### ✅ Architecture Patterns
- **MVVM**: Clear separation between UI and business logic
- **Dependency Injection**: Protocol-based services with function injection
- **Type-Safe Navigation**: Enum-based routing system
- **State Management**: Explicit state enums with exhaustive handling

### ✅ SwiftUI Best Practices
- **Explicit Spacing**: No default padding or spacing values
- **@ViewBuilder**: Only used when necessary for multiple views
- **Navigation**: Modern `NavigationStack` for iOS 16+
- **Modular Components**: Reusable view components with clear APIs

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 16.0+ deployment target
- SwiftLint installed locally

### Installation
1. Clone the repository
2. Open `Subspace.xcodeproj` in Xcode
3. Build and run (⌘+R)

### SwiftLint Setup
```bash
# Install SwiftLint
brew install swiftlint

# Run SwiftLint
swiftlint

# Auto-fix issues (where possible)
swiftlint --fix
```

## 🧪 Testing

The project uses **Swift Testing** framework (iOS 17+) with comprehensive test coverage:

```bash
# Run tests
⌘+U in Xcode
```

### Test Structure
```
SubspaceTests/
└── SubspaceTests.swift    # Comprehensive test suites
    ├── HomeFeatureTests      # Home screen functionality
    ├── ProfileFeatureTests   # Profile screen functionality  
    ├── ServiceTests          # Business logic services
    └── ModelTests           # Data models and utilities
```

### Test Coverage Goals
- **80% minimum** for business logic (ViewModels, Services)
- **Protocol-based mocking** at service boundaries
- **Async/await testing** for all async operations
- **Swift Testing** framework with modern `@Test` syntax

### Test Examples
```swift
@Test("Loading home data succeeds with mock service")
@MainActor
func loadingHomeDataSucceedsWithMockService() async throws {
    // Given
    let mockService = MockMessageService(customMessage: "Test Message")
    let viewModel = HomeViewModel()
    
    // When
    await viewModel.loadHomeData(messageService: mockService)
    
    // Then
    guard case .loaded(let message) = viewModel.state else {
        Issue.record("Expected loaded state")
        return
    }
    #expect(message == "Test Message")
}
```

## 🛠️ Development Standards

### Coding Conventions
- **Naming**: Clear, descriptive names following Swift API guidelines
- **Documentation**: DocC comments for public APIs
- **File Organization**: MARK comments and logical grouping
- **Protocol Conformance**: Extensions for protocol implementations

### Git Workflow
- **Feature Branches**: `feature/description`
- **Commit Messages**: Conventional commits format
- **Pull Requests**: Required for all changes
- **Code Review**: Focus on architecture and patterns

## 📱 Screens

### Home Screen
- Welcome message with loading states
- Quick action cards for navigation
- Recent activity feed
- Pull-to-refresh functionality

### Profile Screen
- User information display
- Avatar with initials fallback
- Error handling with retry
- Skeleton loading states

### Settings Screen
- App information
- User preferences
- Support links
- Version information

## 🔧 Configuration

### Environment Setup
- Development, Staging, Production configurations
- Feature flags for gradual rollouts
- Analytics and crash reporting integration

### Dependencies
- **SwiftUI**: Primary UI framework
- **Foundation**: Core services and networking
- **os**: Structured logging
- **Swift Testing**: Modern unit testing framework (iOS 17+)

## 📋 TODO

### Immediate
- [x] ~~Remove legacy files after migration verification~~ ✅ Legacy files cleaned up
- [x] ~~Add unit tests for all ViewModels~~ ✅ Complete with Swift Testing
- [x] ~~Fix XCTest import issues~~ ✅ Moved to proper test target
- [x] ~~Fix Combine import issues~~ ✅ All ViewModels now import Combine
- [x] ~~Resolve Info.plist conflicts~~ ✅ Build errors resolved
- [ ] Implement actual networking layer
- [ ] Add proper error handling UI

### Backend Integration
- [x] ~~Set up localhost HTTP connections~~ ✅ NSAppTransportSecurity configured
- [ ] Connect to actual API endpoints
- [ ] Add authentication flow
- [ ] Implement data persistence

### Future Enhancements
- [x] ~~Migrate to Swift Testing framework~~ ✅ Complete
- [ ] Add Core Data persistence
- [ ] Implement push notifications
- [ ] Add widget extension
- [ ] Localization support

## 🏆 Best Practices Demonstrated

This codebase demonstrates:

1. **Clean Architecture**: Clear boundaries between layers
2. **SOLID Principles**: Especially Single Responsibility and Dependency Inversion
3. **Modern Swift**: Async/await, actors, structured concurrency
4. **Type Safety**: Tagged types and exhaustive enums
5. **Testing**: Comprehensive unit tests with dependency injection
6. **Documentation**: Clear README and inline documentation
7. **Code Quality**: SwiftLint enforcement and consistent patterns

---

Built with ❤️ following senior iOS development standards.