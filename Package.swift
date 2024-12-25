// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Crypto",
    platforms: [
        .iOS(.v14),      
        .macOS(.v10_15)  
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.5.0") // اضافه کردن Lottie
    ],
    targets: [
        .executableTarget(
            name: "Crypto",
            dependencies: [
                .product(name: "Lottie", package: "lottie-ios") // وابستگی به Lottie
            ]
        )
    ]
)
