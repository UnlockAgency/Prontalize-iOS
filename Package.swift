// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Prontalize",
    defaultLocalization: "en_US",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "Prontalize", targets: ["Prontalize"])
    ],
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector.git", .upToNextMajor(from: "0.9.2"))
    ],
    targets: [
        .target(
            name: "Prontalize",
            path: "Sources"
        ),
        .testTarget(
            name: "ProntalizeTests",
            dependencies: [
                "Prontalize",
                "ViewInspector"
            ],
            path: "TestSources",
            resources: [
                .process("Resources")
            ]
        )
    ],
    swiftLanguageVersions: [ .v5 ]
)

#if swift(>=5.6)
  // Add the documentation compiler plugin if possible
  package.dependencies.append(
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  )
#endif