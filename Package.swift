// swift-tools-version: 5.9
//
// MiniKYCSDK — binary (closed-source) distribution.
//
// The `url` and `checksum` below are updated on every release by the CI
// workflow in the (private) source repo. They point to the pre-built
// .xcframework.zip attached to the matching GitHub Release of this repo.
//
// Consumers install via SPM as usual:
//
//   .package(url: "https://github.com/hesham92/MiniKYCSDK.git", from: "0.2.0")
//
// Source code lives in a private repository. Public API surface is visible
// via the bundled `.swiftinterface` files in the xcframework after install.

import PackageDescription

let package = Package(
    name: "MiniKYCSDK",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "MiniKYCSDK", targets: ["MiniKYCSDK"]),
    ],
    targets: [
        .binaryTarget(
            name: "MiniKYCSDK",
            url: "https://github.com/hesham92/MiniKYCSDK/releases/download/0.2.0/MiniKYCSDK.xcframework.zip",
            checksum: "REPLACE_AFTER_FIRST_BINARY_RELEASE"
        ),
    ]
)
