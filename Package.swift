// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftyAPNS",
    platforms: [
        .iOS(.v14_0),
        .macOS(.v11_0)
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
