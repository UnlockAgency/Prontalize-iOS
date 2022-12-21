# Prontalize iOS SDK

![IOS workflow](https://github.com/unlockagency/prontalize-ios/actions/workflows/ios.yml/badge.svg)
[![codecov](https://codecov.io/gh/UnlockAgency/Prontalize-iOS/branch/main/graph/badge.svg?token=W969TSUSSK)](https://codecov.io/gh/UnlockAgency/Prontalize-iOS) 
[![Platforms](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](Package.swift)
[![SwiftPM compatible](https://img.shields.io/badge/platform-ios%20|%20macos-lightgray.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-black.svg)](LICENSE)

## Implementation

```swift
#if DEBUG
  Prontalize.instance.debugModus = true
#endif

Prontalize.instance.setup(
  apiToken: "api-token",
  projectID: "projectID"
)
```

Always make sure you have a fallback / default localization present in your app's bundle.
Especially for strings that are visible on the first screen of your app.

## Usage

To reload / refresh the bundle:

```swift
Prontalize.instance.refresh()
```

If for some reason you want to disable the live-loaded bundle

```swift
Prontalize.instance.isEnabled = false
```

Or clear the latest downloaded bundle

```swift
Prontalize.instance.clearCache()
```

## SwiftUI

### Default implementation

This text will not update live or on refresh. Only when the view is completely (re)loaded.

```swift
struct ContentView: View {
  var body: some View {
    VStack {
      Text("welcome", bundle: .prontalize)
    }
  }
}
```

Or just use it somewhere else

```swift
let string = NSLocalizedString("welcome", bundle: .prontalize, comment: "")
```

### Live reloading

Using `ProntalizeText` will automatically refresh the text value upon refresh

```swift
VStack {
  ProntalizeText("welcome")
}
```

If you want to keep using `Text`, then add this function to your codebase:

```swift
public func Text(_ string: String, pluralCount: Int? = nil) -> ProntalizedText {
    return ProntalizedText(string, pluralCount: pluralCount)
}
```

So this will also work:

```swift
VStack {
  Text("welcome")
}
```

For plurals if you want to use live reloading:

```swift
VStack {
  Text("apples", pluralCount: 3)
  // -- or --
  PluralText("apples", pluralCount: 3)
}
```

### Radon

Using Radon and automatically refreshing the text values.

Run this command after you've updated your localization files

```bash
#!/bin/sh

sed -i '' 's/bundle: .module/bundle: .prontalize/g' ./Modules/Common/Sources/Generated/Radon+strings.swift
```
