// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "L10nLint",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "l10nlint", targets: ["l10nlint"])
    ],
    dependencies: [
         .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.1"),
         .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.4")
    ],
    targets: [
        .executableTarget(
            name: "l10nlint",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "L10nLintFramework"
            ]
        ),
        .target(
            name: "L10nLintFramework",
            dependencies: [
                .product(name: "Yams", package: "Yams")
            ]
        ),
        .testTarget(
            name: "L10nLintFrameworkTests",
            dependencies: ["L10nLintFramework"],
            exclude: ["Resources"]
        ),
    ]
)
