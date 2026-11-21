# Clean Architecture Implementation

## Project Structure

```
Subspace/
├── App/                                    # Application Entry Point
│   ├── AppApp.swift                       # Main app file
│   └── AppDependencies.swift              # DI container
│
├── Domain/                                 # Business Logic Layer (Pure Swift)
│   ├── Entities/                          # Business Models
│   │   ├── User.swift
│   │   ├── FreshModels.swift
│   │   ├── RecentActivity.swift
│   │   ├── AuthState.swift
│   │   └── OnboardingPage.swift
│   │
│   ├── UseCases/                          # Business Use Cases
│   │   ├── Auth/
│   │   ├── Messages/
│   │   └── Users/
│   │
│   └── Repositories/                      # Repository Protocols
│       └── (Protocol definitions)
│
├── Data/                                   # Frameworks & Drivers Layer
│   ├── Network/                           # Network Implementation
│   │   ├── APIClient.swift
│   │   ├── APIModels.swift
│   │   ├── NetworkError.swift
│   │   ├── RetryPolicy.swift
│   │   ├── SimpleAPIClient.swift
│   │   └── WebSocketManager.swift
│   │
│   ├── Storage/                           # Local Storage
│   │   ├── Cache.swift
│   │   ├── KeychainService.swift
│   │   └── WeatherData.swift
│   │
│   └── Repositories/                      # Repository Implementations
│       └── UserService.swift
│
└── Presentation/                           # UI Layer
    ├── Common/                            # Shared UI Components
    │   ├── DesignSystem/
    │   │   ├── LCARSColors.swift
    │   │   ├── LCARSComponents.swift
    │   │   ├── LCARSFrame.swift
    │   │   ├── AsyncImageView.swift
    │   │   └── ShimmerEffect.swift
    │   │
    │   ├── Extensions/
    │   │   ├── HapticExtensions.swift
    │   │   └── LoggerExtensions.swift
    │   │
    │   └── Components/
    │       └── (Reusable UI components)
    │
    ├── Features/                          # Feature Modules
    │   ├── Auth/
    │   │   ├── ViewModels/
    │   │   │   └── AuthViewModel.swift
    │   │   ├── Views/
    │   │   │   ├── LCARSLoginView.swift
    │   │   │   ├── LCARSSignupView.swift
    │   │   │   ├── LCARSSplashView.swift
    │   │   │   └── LCARSOnboardingView.swift
    │   │   └── Services/
    │   │       ├── AuthService.swift
    │   │       ├── MockAuthService.swift
    │   │       ├── AppleAuthService.swift
    │   │       └── GoogleAuthService.swift
    │   │
    │   ├── Home/
    │   │   ├── ViewModels/
    │   │   │   └── HomeViewModel.swift
    │   │   ├── Views/
    │   │   │   └── LCARSHomeViewIntegrated.swift
    │   │   └── Services/
    │   │       └── MessageService.swift
    │   │
    │   ├── Messages/
    │   │   ├── ViewModels/
    │   │   │   ├── MessagesViewModel.swift
    │   │   │   └── CreateMessageViewModel.swift
    │   │   └── Views/
    │   │       ├── LCARSMessagesViewIntegrated.swift
    │   │       └── CreateMessageView.swift
    │   │
    │   ├── Users/
    │   │   ├── ViewModels/
    │   │   │   └── UsersViewModel.swift
    │   │   └── Views/
    │   │       └── LCARSUsersViewIntegrated.swift
    │   │
    │   ├── Profile/
    │   │   ├── ViewModels/
    │   │   │   └── ProfileViewModel.swift
    │   │   └── Views/
    │   │       └── LCARSProfileViewIntegrated.swift
    │   │
    │   ├── Settings/
    │   │   └── Views/
    │   │       └── LCARSSettingsViewIntegrated.swift
    │   │
    │   └── Dashboard/
    │       └── Views/
    │           └── LCARSDashboardView.swift
    │
    └── Navigation/
        ├── AppRoute.swift                 # Route definitions
        ├── AppRootView.swift              # Root navigation
        └── AuthCoordinator.swift          # Auth flow coordinator
```

## Clean Architecture Principles Applied

### 1. **Dependency Rule**
- Domain layer has NO dependencies on outer layers
- Data layer depends only on Domain
- Presentation layer depends on Domain (not Data directly)
- Dependencies point inward (toward Domain)

### 2. **Layer Responsibilities**

#### Domain Layer (Business Logic)
- **Entities**: Core business models (User, Message, etc.)
- **Use Cases**: Business rules and operations
- **Repository Protocols**: Contracts for data access
- **Pure Swift**: No framework dependencies

#### Data Layer (Frameworks & Drivers)
- **Network**: API clients, WebSocket managers
- **Storage**: Keychain, Cache, local persistence
- **Repository Implementations**: Conform to Domain protocols
- **Framework-specific code**: URLSession, Keychain, etc.

#### Presentation Layer (UI)
- **Features**: Organized by feature (Auth, Home, Messages, etc.)
- **ViewModels**: Presentation logic, uses Domain use cases
- **Views**: SwiftUI views (LCARS-themed)
- **Navigation**: Routing and coordinator pattern
- **Common**: Shared design system, extensions, components

### 3. **Benefits Achieved**

✅ **Testability**: Domain logic isolated, easy to test
✅ **Maintainability**: Clear separation of concerns
✅ **Scalability**: Easy to add new features
✅ **Independence**: UI framework can be changed without affecting business logic
✅ **Reusability**: Domain layer reusable across platforms (iOS, macOS, etc.)

## File Organization Rules

### Domain/
- Only Swift foundation imports
- No UIKit, SwiftUI, or external frameworks
- Protocol-based repository interfaces
- Pure business logic

### Data/
- Framework implementations (URLSession, Keychain)
- Conform to Domain repository protocols
- Handle data transformation (DTO → Entity)
- Error handling and retry logic

### Presentation/
- SwiftUI views and ViewModels
- LCARS design system
- Feature-based organization
- Navigation and routing

## Testing Strategy

### Domain Tests (Unit Tests)
- Test use cases in isolation
- Mock repository protocols
- Pure Swift testing

### Data Tests (Integration Tests)
- Test repository implementations
- Test network/storage layers
- Mock external dependencies

### Presentation Tests (UI Tests)
- Test ViewModel logic
- Test view state management
- Snapshot tests for LCARS components

## Migration Benefits

**Before**: 67 files in flat/nested structure
**After**: 50 files in Clean Architecture (25% reduction + proper organization)

### Key Improvements:
1. ✅ Clear layer separation
2. ✅ Feature-based organization
3. ✅ Testable architecture
4. ✅ Dependency inversion
5. ✅ Single Responsibility Principle
6. ✅ Easy to navigate and maintain

## Next Steps

1. **Complete Domain Layer**:
   - Extract use cases from ViewModels
   - Create repository protocols
   - Move business logic to use cases

2. **Enhance Data Layer**:
   - Implement repository pattern fully
   - Add error handling strategies
   - Implement caching strategies

3. **Refine Presentation**:
   - Extract common view components
   - Implement coordinator pattern completely
   - Add navigation state management

4. **Add Tests**:
   - Unit tests for Domain use cases
   - Integration tests for Data repositories
   - UI tests for critical flows
