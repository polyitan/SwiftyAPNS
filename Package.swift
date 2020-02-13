// swift-tools-version:4.2
//
// swift-tools-version:4.2
//

import PackageDescription

let package = Package(
    name: "SwiftyAPNS",
    products: [
        .library(
            name: "SwiftyAPNS",
            targets: ["SwiftyAPNS"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftyAPNS",
            dependencies: []),
        .testTarget(
            name: "SwiftyAPNSTests",
            dependencies: []
        ),
    ]
)
