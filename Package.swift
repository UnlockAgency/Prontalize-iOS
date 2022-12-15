// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Prontalize",
    defaultLocalization: "en_US",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Prontalize", targets: ["Prontalize"])
    ],
    targets: [
        .target(
            name: "Prontalize",
            path: "Sources"
        ),
        .testTarget(
            name: "ProntalizeTests",
            dependencies: [
                "Prontalize"
            ],
            path: "TestSources",
            resources: [
                .process("Resources")
            ]
        )
    ],
    swiftLanguageVersions: [ .v5 ]
)
