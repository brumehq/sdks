// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Brume",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "Brume",
            targets: ["Brume"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Brume",
            path: "Sources"
        ),
        .testTarget(
            name: "BrumeTests",
            dependencies: ["Brume"],
            path: "Tests"
        )
    ]
)
