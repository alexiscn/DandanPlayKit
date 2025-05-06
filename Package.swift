// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "DandanplayKit",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(name: "DandanplayKit", targets: ["DandanplayKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/alexiscn/Just", branch: "master"),
    ],
    targets: [
        .target(name: "DandanplayKit", dependencies: ["Just"], path: "Sources"),
    ]
)
