// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftyAPNS",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(name: "SwiftyAPNS", targets: ["SwiftyAPNS"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftyAPNS", dependencies: []),
        .testTarget(name: "SwiftyAPNSTests", dependencies: [])
    ]
)
