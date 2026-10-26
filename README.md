# Subspace

A messaging app for iOS with an LCARS-inspired interface, built in SwiftUI against its own Go
backend ([LCARS-BE-GO](https://github.com/cliftonia/LCARS-BE-GO)).

## What's in it

- **Auth**: Sign in with Apple and Google, onboarding, tokens kept in the Keychain
- **Messages, Users, Profile, Dashboard**: feature modules, each with its own views and view models
- **Networking**: an `APIClient` with a retry policy, typed network errors, a response cache,
  and a `WebSocketManager` for live updates
- **Design system**: a standalone `ComponentLibrary` target with a showcase app, LCARS colours,
  frames, components and sound

## Architecture

Clean Architecture, with dependencies pointing inward:

```
Presentation (SwiftUI views, view models, navigation)
      ↓
Domain (entities, use cases, repository protocols — pure Swift)
      ↑
Data (API client, WebSockets, Keychain, cache, repository implementations)
```

The full layer map and rules are in [`CLEAN_ARCHITECTURE.md`](CLEAN_ARCHITECTURE.md). SwiftLint runs in CI
on every push.

## Running it

1. Start the backend: see [`BACKEND_SETUP.md`](BACKEND_SETUP.md) (Go or Docker, serves `localhost:8080`)
2. Open `Subspace.xcodeproj` and run the **Subspace** scheme on a simulator

The component library can be run on its own via the **ComponentLibrary** scheme.
