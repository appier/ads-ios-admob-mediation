import AppierAds
import GoogleMobileAds

@objc public class APRAdMobBannerAd: NSObject {

    private var bannerAds: APRBannerAd!
    private var delegate: GADMediationBannerAdEventDelegate?
    private var completionHandler: GADMediationBannerLoadCompletionHandler?

    private var bannerView: UIView?

    public private(set) var adUnitId: String
    public private(set) var zoneId: String
    public private(set) var appInfo: Any?

    override init() {
        adUnitId = ""
        zoneId = ""
        super.init()
    }

    func load(adConfiguration: AdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        let localExtras = adConfiguration.getLocalExtras()
        guard let adUnitId = localExtras.get(key: .adUnitId) as? String else {
            delegate = completionHandler(self, APRError(type: .adUnitIdError))
            return
        }
        guard let zoneId = localExtras.get(key: .zoneId) as? String else {
            delegate = completionHandler(self, APRError(type: .zoneIdError))
            return
        }
        self.adUnitId = adUnitId
        self.zoneId = zoneId
        self.appInfo = localExtras.get(key: .appInfo)
        self.completionHandler = completionHandler
        bannerAds = .init(adUnitId: APRAdMobAdUnitId(adUnitId))
        bannerAds?.set(extras: localExtras)
        bannerAds?.delegate = self
        bannerAds?.load()
    }

}

@objc
extension APRAdMobBannerAd: GADMediationBannerAd {
    public var view: UIView {
        bannerView ?? UIView()
    }
}

@objc
extension APRAdMobBannerAd: APRBannerAdDelegate {
    public func onAdNoBid(_ bannerAd: AppierAds.APRBannerAd) {
        logger.debug("\(#function)")
    }

    public func onAdLoaded(_ bannerAd: AppierAds.APRBannerAd, banner: UIView) {
        logger.debug("\(#function)")
        self.bannerView = banner
        self.delegate = self.completionHandler?(self, nil)
    }

    public func onAdLoadedFailed(
        _ bannerAd: AppierAds.APRBannerAd,
        error: AppierAds.APRError
    ) {
        logger.debug("\(#function)")
        self.delegate = self.completionHandler?(self, error)
    }

    public func onAdImpressionRecorded(_ bannerAd: AppierAds.APRBannerAd) {
        logger.debug("\(#function)")
        APRAdMobAdManager.shared.eventDelegate?.onBannerAdImpressionRecorded?(bannerAd: self)
    }

    public func onAdImpressionRecordedFailed(
        _ bannerAd: AppierAds.APRBannerAd,
        error: AppierAds.APRError
    ) {
        logger.debug("\(#function)")
        APRAdMobAdManager.shared.eventDelegate?.onBannerAdImpressionRecordedFailed?(
            bannerAd: self,
            error: error
        )
    }

    public func onAdClickedRecorded(_ bannerAd: AppierAds.APRBannerAd) {
        logger.debug("\(#function)")
        APRAdMobAdManager.shared.eventDelegate?.onBannerAdClickedRecorded?(bannerAd: self)
    }

    public func onAdClickedRecordedFailed(
        _ bannerAd: AppierAds.APRBannerAd,
        error: AppierAds.APRError
    ) {
        logger.debug("\(#function)")
        APRAdMobAdManager.shared.eventDelegate?.onBannerAdClickedRecordedFailed?(
            bannerAd: self,
            error: error
        )
    }
}
