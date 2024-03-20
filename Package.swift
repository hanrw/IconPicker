// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IconPicker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "IconPicker",
            targets: ["IconPicker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onmyway133/Smile.git", from: "2.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "IconPicker",
            dependencies: ["Smile"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "IconPickerTests",
            dependencies: ["IconPicker"]),
    ]
)
