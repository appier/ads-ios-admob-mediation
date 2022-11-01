import ProjectDescription
import AppierAdsAdMobMediation

let lintAction = TargetAction.post(path: "../scripts/lint.sh", name: "SwiftLint")

let framework = Target(
    name: "AppierAdsAdMobMediation",
    platform: .iOS,
    product: .framework,
    bundleId: "com.appier.AppierAdsAdMobMediationSdk",
    deploymentTarget: .iOS(targetVersion: "12.0", devices: [.iphone, .ipad]),
    infoPlist: .file(path: .relativeToCurrentFile("../Info.plist")),
    sources: appierAdsAdMobMediationSdk.sources,
    resources: appierAdsAdMobMediationSdk.resources,
    headers: Headers(
        public: FileList(globs: (appierAdsAdMobMediationSdk.headers.public ?? []).globs + (appierAdsAdMobMediationSdk.mainHeader.public ?? []).globs),
        private: FileList(globs: (appierAdsAdMobMediationSdk.headers.private ?? []).globs + (appierAdsAdMobMediationSdk.mainHeader.private ?? []).globs),
        project: FileList(globs: (appierAdsAdMobMediationSdk.headers.project ?? []).globs + (appierAdsAdMobMediationSdk.mainHeader.project ?? []).globs)
    ),
    actions: [lintAction],
    settings: Settings(base: [
        "MARKETING_VERSION": .string("1.2.1"),
        "CURRENT_PROJECT_VERSION": .string("0"),
        "SKIP_INSTALL": "NO",
        "BUILD_LIBRARY_FOR_DISTRIBUTION": "YES",
        "SUPPORTS_MACCATALYST": "NO",
        "APPLICATION_EXTENSION_API_ONLY": "NO",
        "GCC_PREPROCESSOR_DEFINITIONS": .string("$(inherited) \("APPIER_ADS_ADMOB_MEDIATION_SDK=1")"),
        "OTHER_SWIFT_FLAGS": .string("$(inherited) \("")")
    ])
)

let frameworkTests = Target(
    name: "AppierAdsAdMobMediationTests",
    platform: .iOS,
    product: .unitTests,
    bundleId: "com.appier.AppierAdsAdMobMediationSdkTests",
    deploymentTarget: .iOS(targetVersion: "12.0", devices: [.iphone, .ipad]),
    infoPlist: .default,
    sources: appierAdsAdMobMediationSdkUnitTests.sources,
    resources: appierAdsAdMobMediationSdkUnitTests.resources,
    headers: nil,
    dependencies: [.target(name: "AppierAdsAdMobMediation")],
    settings: Settings(base: [
        "GCC_PREPROCESSOR_DEFINITIONS": .string("$(inherited) \("APPIER_ADS_ADMOB_MEDIATION_SDK=1")")
    ])
)

let appierAdsAdMobMediationSdkScheme = Scheme(
    name: "AppierAdsAdMobMediation",
    buildAction: BuildAction(targets: ["AppierAdsAdMobMediation"]),
    testAction: TestAction(
        targets: ["AppierAdsAdMobMediationTests"],
        arguments: Arguments(environment: [
            "CI": (Environment.isCI?.getBoolean(default: false) ?? false) ? "YES" : "NO"
        ])
    )
)

Project(
    name: "AppierAdsAdMobMediationSdk",
    organizationName: "Appier Inc.",
    packages: [],
    settings: Settings(configurations: [
        CustomConfiguration.debug(name: "Debug", xcconfig: Path.relativeToCurrentFile("../Configurations/Debug.xcconfig")),
        CustomConfiguration.debug(name: "Staging", xcconfig: Path.relativeToCurrentFile("../Configurations/Staging.xcconfig")),
        CustomConfiguration.release(name: "Release", xcconfig: Path.relativeToCurrentFile("../Configurations/Release.xcconfig"))
    ]),
    targets: [
        framework,
        frameworkTests
    ],
    schemes: [
        appierAdsAdMobMediationSdkScheme
    ]
)
