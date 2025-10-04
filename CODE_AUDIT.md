# Code Audit Summary

## Files to Remove (Unused Code)

### 1. **SimpleAPIClient.swift** - UNUSED
- **Location**: `Data/Network/CoreNetworkingSimpleAPIClient.swift`
- **Reason**: Not referenced anywhere in the codebase. APIClient.swift is used instead.
- **Action**: DELETE

### 2. **LCARSFrame.swift** - UNUSED
- **Location**: `Presentation/Common/DesignSystem/CoreDesignSystemLCARSFrame.swift`
- **Reason**: Only used in Dashboard (1 usage). All integrated views have custom LCARS frames built-in.
- **Action**: DELETE and simplify Dashboard

### 3. **ShimmerEffect.swift** - UNUSED
- **Location**: `Presentation/Common/DesignSystem/CoreDesignSystemShimmerEffect.swift`
- **Reason**: Not used anywhere in the codebase.
- **Action**: DELETE

### 4. **AsyncImageView.swift** - UNUSED
- **Location**: `Presentation/Common/DesignSystem/CoreDesignSystemAsyncImageView.swift`
- **Reason**: Not used anywhere. SwiftUI's AsyncImage is sufficient.
- **Action**: DELETE

### 5. **GoogleAuthService.swift** - NOT IMPLEMENTED
- **Location**: `Presentation/Features/Auth/FeaturesAuthServicesGoogleAuthService.swift`
- **Reason**: Placeholder implementation that throws `.notImplemented` error.
- **Action**: KEEP but simplify (remove all placeholder comments)

### 6. **AppleAuthService.swift** - NOT FULLY INTEGRATED
- **Location**: `Presentation/Features/Auth/FeaturesAuthServicesAppleAuthService.swift`
- **Reason**: Implemented but unused in AuthViewModel (never called from UI).
- **Action**: KEEP but verify integration

## Code Simplification Opportunities

### 1. **AuthViewModel**
- **Issue**: Accepts AppleAuthService and GoogleAuthService but Google is not implemented
- **Action**: Make Google auth optional, simplify initialization

### 2. **RetryPolicy**
- **Issue**: Comprehensive retry logic but may not be used extensively
- **Action**: Keep but verify usage in APIClient

### 3. **Cache**
- **Issue**: Generic cache with CachedService wrapper, but usage is unclear
- **Action**: Verify usage and simplify if only used for images

### 4. **Duplicate LCARS Random Code Generation**
- **Issue**: Each integrated view has its own `randomDigits()` function
- **Action**: Extract to shared LCARS utilities

## Test Coverage Analysis

### Current Coverage (3 test files, 11 tests):
1. **AuthViewModelTests** - 5 tests
2. **KeychainServiceTests** - 3 tests
3. **HomeViewModelTests** - 3 tests

### Missing Tests (To Reach 60%):
1. **APIClient** - Network layer (critical)
2. **WebSocketManager** - Real-time updates
3. **MessageService** - Business logic
4. **UserService** - User operations
5. **MessagesViewModel** - Messaging logic
6. **UsersViewModel** - User list logic
7. **ProfileViewModel** - Profile operations
8. **CreateMessageViewModel** - Message creation
9. **NetworkError** - Error handling
10. **Cache** - Caching logic

## Refactoring Priorities

### High Priority:
1. Remove unused files (SimpleAPIClient, LCARSFrame, ShimmerEffect, AsyncImageView)
2. Extract common LCARS utilities
3. Add APIClient tests
4. Add ViewModel tests

### Medium Priority:
1. Simplify AuthViewModel initialization
2. Add WebSocket tests
3. Add Service layer tests
4. Verify RetryPolicy usage

### Low Priority:
1. Document why Google auth is placeholder
2. Improve error handling consistency
3. Add integration tests
