# LCARS Component Library

A SwiftUI component library implementing the LCARS (Library Computer Access/Retrieval System) design system from Star Trek.

The components live in the `LCARSComponents` Swift package at the root of this repository. This app is a showcase for them and imports that package, so it always shows exactly what Subspace ships.

## Running the Showcase

1. Select the `ComponentLibrary` scheme in Xcode
2. Choose your target simulator or device
3. Press ⌘R to run

## Setup

Call `LCARSFonts.register()` once at launch to make the bundled typefaces available.

## Components Usage

### Console

```swift
LCARSConsole(
    header: LCARSConsoleHeader(
        title: "OPERATIONS",
        code: "1-5631",
        accent: .lcarOrange,
        secondary: .lcarPink,
        railColors: [.lcarOrange, .lcarTan, .lcarViolet, .lcarGold]
    )
) {
    Button("OPS") {}
        .buttonStyle(.lcars(.lcarOrange, form: .segment))
} content: {
    Text("Any SwiftUI content")
}
```

### Controls

```swift
Button("Engage") {}
    .buttonStyle(.lcars(.lcarOrange))

Toggle("Shields", isOn: $isOn)
    .toggleStyle(.lcars(.lcarViolet))

LCARSTextField(placeholder: "PERSONNEL ID", text: $text)
LCARSKeyboard(text: $text)
```

### Layout Elements

#### LCARSPanel
```swift
LCARSPanel(
    color: .lcarViolet,
    height: 100,
    cornerRadius: 40,
    label: "01-847293"
)
```

#### LCARSElbow

A `Shape` with independent outer and inner curves:

```swift
LCARSElbow(corner: .topLeading, armWidth: 92, railHeight: 16, outerRadius: 56, innerRadius: 26)
    .fill(Color.lcarOrange)
```

#### LCARSBar & LCARSEndCap
```swift
HStack(spacing: 0) {
    LCARSEndCap(position: .leading, color: .lcarOrange)
    LCARSBar(orientation: .horizontal, color: .lcarOrange, length: 200)
    LCARSEndCap(position: .trailing, color: .lcarOrange)
}
```

#### LCARSBracket
```swift
LCARSBracket(color: .lcarViolet, label: "SYSTEMS") {
    VStack {
        Text("Power: Online")
        Text("Shields: 100%")
    }
}
```

### Indicators

#### LCARSGauge
```swift
LCARSGauge(
    value: 75,
    in: 0...100,
    color: .lcarOrange,
    label: "POWER SYSTEMS"
)
```

#### LCARSSegmentedGauge
```swift
LCARSSegmentedGauge(
    value: 60,
    segments: 10,
    color: .lcarTan,
    label: "SENSOR ARRAY"
)
```

### Utilities

#### LCARSUtilities

```swift
// Digits that read the same on every redraw, for labels in view code
LCARSUtilities.stableDigits("CREW", count: 4)

// Fresh random values, for anything outside a view body
LCARSUtilities.randomDigits(5)
LCARSUtilities.lcarCode(prefix: "ACCESS", digits: 3)
LCARSUtilities.systemCode(section: "01")
```

### Typography

```swift
Text("ACCESS GRANTED").font(.lcars(24))         // LCARS GTJ3 display type
Text("Welcome aboard.").font(.lcarsBody(17))    // Antonio reading type
```

### Color Palette

The Classic theme values published at thelcars.com/colors.php:

```swift
Color.lcarOrange       // #EB943A
Color.lcarLightOrange  // #EDB378
Color.lcarGold         // #EA9C72
Color.lcarTan          // #FCC19F
Color.lcarPink         // #C082A9
Color.lcarViolet       // #BAA4E5
Color.lcarBlue         // #8899FF
Color.lcarPlum         // #C47D69
Color.lcarRed          // #CF4F4F
Color.lcarAlert        // #FF2200
```

## Design Philosophy

1. **Black structure**: black space and thin gutters organise the screen
2. **True elbows**: a broad arm sweeps into a thin rail through two separate curves
3. **Flat colour**: no glow, gradients or glass
4. **Condensed type**: natural-width fonts, never squeezed with a scale transform
5. **Native controls**: styles sit on SwiftUI buttons and toggles, so accessibility is kept

## Credits

Inspired by the original LCARS design by Michael Okuda for Star Trek: The Next Generation.

Typefaces: LCARS GTJ3 by GTJLCARS.de and Antonio by Vernon Adams (Open Font License).
