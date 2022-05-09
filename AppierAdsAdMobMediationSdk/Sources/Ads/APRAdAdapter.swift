import GoogleMobileAds
import AppierAds

@objc public class APRAdAdapter: NSObject, GADMediationAdapter {
    var extras: APRAdExtras?
    var nativeAd: APRAdMobNativeAd?
    
    @objc public static func adapterVersion() -> GADVersionNumber {
        let numbers = versionNumbers(versionString: APRAdMobMediation.shared.version)
        if numbers.count != 3 {
            return .init()
        }
        return .init(majorVersion: numbers[0], minorVersion: numbers[1], patchVersion: numbers[2])
    }
    
    @objc public static func adSDKVersion() -> GADVersionNumber {
        let numbers = versionNumbers(versionString: APRAds.shared.version)
        if numbers.count != 3 {
            return .init()
        }
        return .init(majorVersion: numbers[0], minorVersion: numbers[1], patchVersion: numbers[2])
    }
    
    @objc public static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        return APRAdExtras.self
    }
    
    private static func versionNumbers(versionString: String) -> [Int] {
        let components = versionString.components(separatedBy: ".")
        return components.map { component in
            return Int(component) ?? 0
        }
    }
    
    @objc public override required init() {
        super.init()
    }
    
    @objc public func loadNativeAd(for adConfiguration: GADMediationNativeAdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        logger.debug("\(#function)")
        nativeAd = .init()
        nativeAd?.load(adConfiguration: .init(with: adConfiguration), completionHandler: completionHandler)
    }
}

struct AdMobServerExtras: Codable {
    var adUnitId: String?
    var zoneId: String?
}
