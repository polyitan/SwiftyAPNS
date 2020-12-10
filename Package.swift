// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftyAPNS",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "SwiftyAPNS", targets: ["SwiftyAPNS"])
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
