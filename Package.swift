// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "SwiftyAPNS",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftyAPNS",
            targets: ["SwiftyAPNS"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftyAPNS",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftyAPNSTests",
            dependencies: ["SwiftyAPNS"],
            resources: [
                .process("CertificateConfig.plist"),
                .process("KeyConfig.plist")
            ]
        )
    ]
)
