// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "L10nLint",
    dependencies: [
         .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.1"),
    ],
    targets: [
        .executableTarget(
            name: "l10nlint",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "L10nLintFramework"
            ]),
        .target(name: "L10nLintFramework"),
        .testTarget(
            name: "L10nLintFrameworkTests",
            dependencies: ["L10nLintFramework"],
            exclude: ["Resources"]),
    ]
)
