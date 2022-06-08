import Foundation
import AppierAds


@objc class APRAdMobAdUnitId: NSObject, APRAdUnitIdentifier {
    private var adUnitId: String

    @objc public init(_ adUnitId: String) {
        self.adUnitId = adUnitId
        super.init()
    }

    @objc public func get() -> String {
        return adUnitId
    }

    @objc public func build() -> String {
        return "admob_\(adUnitId)"
    }
}
