import ProjectDescription

public struct Files {
    public let sources: SourceFilesList
    public let resources: ResourceFileElements
    public let headers: Headers
    public let mainHeader: Headers

    public init(
        sources: SourceFilesList,
        resources: ResourceFileElements = [],
        headers: Headers = Headers(),
        mainHeader: Headers = Headers()
    ) {
        self.sources = sources
        self.resources = resources
        self.headers = headers
        self.mainHeader = mainHeader
    }
}

public let appierAdsAdMobMediationSdk = Files(
    sources: [
        SourceFileGlob(.relativeToCurrentFile("../AppierAdsAdMobMediationSdk/Sources/**"))
    ],
    resources: [],
    headers: Headers(),
    mainHeader: Headers(
        public: FileList(globs: [
            .relativeToCurrentFile("../AppierAdsAdMobMediationSdk/Sources/Public/AppierAdsAdMobMediationSdk.h")
        ])
    )
)

public let appierAdsAdMobMediationSdkUnitTests = Files(
    sources: [
        SourceFileGlob(.relativeToCurrentFile("../AppierAdsAdMobMediationSdk/Tests/**"))
    ],
    resources: [
        .glob(pattern: .relativeToCurrentFile("../AppierAdsAdMobMediationSdk/Tests/*.png"))
    ]
)
