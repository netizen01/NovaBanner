// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NovaBanner",
    products: [
        .library(name: "NovaBanner", targets: ["NovaBanner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/netizen01/NovaCore", .branch("master")),
        .package(url: "https://github.com/robb/Cartography", .branch("master"))
    ],
    targets: [
        .target(name: "NovaBanner", dependencies: ["Cartography", "NovaCore"])
    ]
)
