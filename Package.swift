// swift-tools-version:5.7.1
import PackageDescription

let package = Package(
    name: "AppierAdsAdMobMediation",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "AppierAdsAdMobMediation",
            targets: ["AppierAdsAdMobMediationWrapper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", from: "12.4.0")
    ],
    targets: [
        .binaryTarget(
            name: "AppierAdsAdMobMediation",
            path: "AppierAdsAdMobMediation.xcframework"
        ),
        .target(
            name: "AppierAdsAdMobMediationWrapper",
            dependencies: [
                .target(name: "AppierAdsAdMobMediation"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
            path: "Sources/AppierAdsAdMobMediationWrapper"
        )
    ]
)
