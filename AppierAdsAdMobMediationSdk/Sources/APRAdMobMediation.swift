import Foundation
import AppierAds

@objc public final class APRAdMobMediation: NSObject {
    @objc public static let shared = {
        return APRAdMobMediation()
    }()
    
    private override init() { super.init() }
    
    @objc public let advertiserIcon = "advertiser_icon"
    @objc public let advertiserName = "Appier"
    
    @objc public let version = {
        return Bundle(for: APRAdMobMediation.self).object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    }()
}
