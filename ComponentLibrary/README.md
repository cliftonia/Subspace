# LCARS Component Library

A SwiftUI component library implementing the LCARS (Library Computer Access/Retrieval System) design system from Star Trek.

## Features

### Components

- **LCARSButton**: Interactive buttons with customizable colors, sizes, and labels
- **LCARSPanel**: Colored panels with configurable heights and corner radii
- **LCARSColors**: Complete LCARS color palette
- **LCARSUtilities**: Helper functions for generating LCARS codes and identifiers

### Showcase App

The Component Library includes a showcase app that demonstrates all available components with live examples.

## Setup

### Adding as a Target in Xcode

1. Open `Subspace.xcodeproj` in Xcode
2. File → New → Target
3. Choose "iOS" → "App"
4. Product Name: `ComponentLibrary`
5. Interface: SwiftUI
6. Language: Swift
7. Click Finish

### Adding Source Files

1. In the Project navigator, right-click on `ComponentLibrary` folder
2. Add Files to "ComponentLibrary"...
3. Navigate to `ComponentLibrary/Sources/`
4. Select both `Components` and `Showcase` folders
5. Check "Create groups"
6. Add to target: ComponentLibrary
7. Click Add

### Running the Showcase

1. Select the `ComponentLibrary` scheme in Xcode
2. Choose your target simulator/device
3. Press ⌘R to run

## Components Usage

### LCARSButton

```swift
LCARSButton(
    action: { print("Tapped!") },
    color: .lcarOrange,
    width: 125,
    height: 50,
    cornerRadius: 20,
    label: "7724-891"
)
```

### LCARSPanel

```swift
LCARSPanel(
    color: .lcarViolet,
    height: 100,
    cornerRadius: 40,
    label: "01-847293"
)
```

### LCARSUtilities

```swift
// Generate random digits
LCARSUtilities.randomDigits(5) // "84729"

// Generate LCARS code
LCARSUtilities.lcarCode() // "LCARS 84729"
LCARSUtilities.lcarCode(prefix: "ACCESS", digits: 3) // "ACCESS 847"

// Generate system code
LCARSUtilities.systemCode(section: "01") // "01-847293"
```

### Color Palette

```swift
Color.lcarOrange       // #FF9900
Color.lcarPink         // #CC6699
Color.lcarViolet       // #9966FF
Color.lcarPlum         // #9966CC
Color.lcarTan          // #CC9966
Color.lcarLightOrange  // #FF9966
Color.lcarWhite        // #FFFFFF
Color.lcarBlack        // #000000
```

## Design Philosophy

The LCARS design system follows these principles:

1. **Bold Colors**: High contrast colors for maximum visibility
2. **Rounded Corners**: Distinctive rounded rectangles
3. **Condensed Typography**: HelveticaNeue-CondensedBold for all text
4. **Functional Aesthetics**: Every element serves a purpose
5. **System Codes**: Random alphanumeric identifiers throughout

## Credits

Inspired by the original LCARS design by Michael Okuda for Star Trek: The Next Generation.

Component implementation based on the SciFiChallenge project.
