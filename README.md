# Prontalize iOS SDK

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
typealias PText = ProntalizeText

VStack {
	PText("welcome")
}
```

### Radon

Using Radon and automatically refreshing the text values.

```swift
struct ProntalizeString: CustomDebugStringConvertible {
	let key: String
	
	init(_ key: String) {
		self.key = key
	}
	
	var debugDescription: String {
		return key
	}
}

extension Text {
	init(_ prontalizeString: ProntalizeString) {
		ProntalizeText(prontalizeString.key)
	}
}

extension Radon {
	public enum strings {
		public static var `welcome`: ProntalizeString { ProntalizeString("welcome") }
	}
}

typealias RS = Radon.strings

struct SomeView: View {
	var body: some View {
		VStack {
			Text(RS.welcome)
		}
	}
}

```