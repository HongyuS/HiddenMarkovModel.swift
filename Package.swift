// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HiddenMarkovModel",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "HiddenMarkovModel",
            targets: ["HiddenMarkovModel"]),
    ],
    dependencies: [
        .package(url: "https://github.com/HongyuS/LANumerics", .upToNextMinor(from: "0.1.11")),
        .package(url: "https://github.com/apple/swift-numerics", .upToNextMinor(from: "0.1.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "HiddenMarkovModel",
            dependencies: ["LANumerics", .product(name: "Numerics", package: "swift-numerics")]),
        .testTarget(
            name: "HmmTests",
            dependencies: ["HiddenMarkovModel"]),
    ]
)
