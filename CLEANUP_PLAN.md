# Project Cleanup & Reorganization Plan

## Files to Delete (Unused/Duplicate)

### Unused Legacy Files
- `ContentView.swift` - Legacy redirect, not used
- `ContentViewModel.swift` - Legacy, marked for deletion
- `ContentViewModelTests.swift` - Tests for unused ViewModel
- `SubspaceApp.swift` - Duplicate of AppApp.swift

### Duplicate LCARS Views (Non-Integrated Versions)
- `FeaturesHomeViewsHomeView.swift` - Using integrated version
- `FeaturesHomeViewsLCARSHomeView.swift` - Using integrated version
- `FeaturesMessagesViewsMessagesView.swift` - Using integrated version
- `FeaturesMessagesViewsLCARSMessagesView.swift` - Using integrated version
- `FeaturesUsersViewsUsersView.swift` - Using integrated version
- `FeaturesUsersViewsLCARSUsersView.swift` - Using integrated version
- `FeaturesProfileViewsProfileView.swift` - Using integrated version
- `FeaturesProfileViewsLCARSProfileView.swift` - Using integrated version
- `FeaturesSettingsViewsSettingsView.swift` - Using integrated version
- `FeaturesSettingsViewsLCARSSettingsView.swift` - Using integrated version

### Duplicate Auth Views (Non-LCARS Versions)
- `FeaturesAuthViewsLoginView.swift` - Using LCARS version
- `FeaturesAuthViewsSignupView.swift` - Using LCARS version
- `FeaturesAuthViewsSplashView.swift` - Using LCARS version
- `FeaturesAuthViewsOnboardingView.swift` - Using LCARS version

### Unused Networking Files
- `CoreNetworkingTestAPIClient.swift` - Test file not in use

## Combine → Async/Await Replacements

### Files Using Combine (to update):
1. `CoreServicesWeatherData.swift` - Uses @Published, ObservableObject
2. `FeaturesHomeViewsLCARSHomeViewIntegrated.swift` - Import only, not using
3. `FeaturesHomeViewsLCARSHomeView.swift` - Import only, not using
4. `FeaturesHomeViewsHomeView.swift` - Import only, not using

**Action**: Remove Combine import from files not using it, keep ObservableObject (which is now part of Observation framework in iOS 17+)

## Clean Architecture Structure

### Current Structure:
```
Subspace/
├── App/
├── Core/
│   ├── DesignSystem/
│   ├── Extensions/
│   ├── Models/
│   ├── Networking/
│   ├── Services/
│   └── Storage/
└── Features/
    ├── Auth/
    ├── Dashboard/
    ├── Home/
    ├── Messages/
    ├── Profile/
    ├── Settings/
    ├── Shared/
    └── Users/
```

### Proposed Clean Architecture:
```
Subspace/
├── App/
│   ├── AppApp.swift
│   ├── AppDependencies.swift
│   └── Configuration/
├── Domain/ (Business Logic)
│   ├── Entities/
│   │   ├── User.swift
│   │   └── Message.swift
│   ├── UseCases/
│   │   ├── Auth/
│   │   ├── Messages/
│   │   └── Users/
│   └── RepositoryInterfaces/
├── Data/ (Frameworks & Drivers)
│   ├── Network/
│   ├── Storage/
│   └── Repositories/
└── Presentation/ (UI)
    ├── Common/
    │   ├── DesignSystem/
    │   ├── Extensions/
    │   └── Components/
    ├── Features/
    │   ├── Auth/
    │   ├── Home/
    │   ├── Messages/
    │   └── Users/
    └── Navigation/
```

## Testing Strategy

### Swift Testing Tests to Write:
1. **Domain Layer**:
   - `AuthUseCaseTests.swift`
   - `MessageUseCaseTests.swift`
   - `UserUseCaseTests.swift`

2. **Data Layer**:
   - `AuthRepositoryTests.swift`
   - `MessageRepositoryTests.swift`
   - `KeychainServiceTests.swift`

3. **Presentation Layer**:
   - `AuthViewModelTests.swift`
   - `HomeViewModelTests.swift`
   - `MessagesViewModelTests.swift`

## Implementation Steps

1. ✅ Create cleanup plan
2. Delete unused files
3. Remove Combine imports
4. Reorganize to Clean Architecture
5. Write Swift Testing tests
6. Update documentation
