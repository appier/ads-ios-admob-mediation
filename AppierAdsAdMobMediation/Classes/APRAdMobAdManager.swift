import AppierAds
import GoogleMobileAds

@objc public final class APRAdMobAdManager: NSObject {
    @objc public static let shared = {
        return APRAdMobAdManager()
    }()

    private override init() { super.init() }

    @objc public weak var eventDelegate: APRAdMobAdEventDelegate?
}

@objc public protocol APRAdMobAdEventDelegate: AnyObject {
    @objc optional func onNativeAdImpressionRecorded(nativeAd: APRAdMobNativeAd)
    @objc optional func onNativeAdImpressionRecordedFailed(nativeAd: APRAdMobNativeAd, error: APRError)
    @objc optional func onNativeAdClickedRecorded(nativeAd: APRAdMobNativeAd)
    @objc optional func onNativeAdClickedRecordedFailed(nativeAd: APRAdMobNativeAd, error: APRError)

    @objc optional func onBannerAdImpressionRecorded(bannerAd: APRAdMobBannerAd)
    @objc optional func onBannerAdImpressionRecordedFailed(bannerAd: APRAdMobBannerAd, error: APRError)
    @objc optional func onBannerAdClickedRecorded(bannerAd: APRAdMobBannerAd)
    @objc optional func onBannerAdClickedRecordedFailed(bannerAd: APRAdMobBannerAd, error: APRError)
}
