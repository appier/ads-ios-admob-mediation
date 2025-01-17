import AppierAds
import GoogleMobileAds

@objc public class APRAdMobInterstitialAd: NSObject {
    private var interstitialAd: APRInterstitialAd?
    var delegate: GADMediationInterstitialAdEventDelegate?
    var completionHandler: GADMediationInterstitialLoadCompletionHandler?

    public private(set) var adUnitId: String
    public private(set) var zoneId: String
    public private(set) var appInfo: Any?

    override init() {
        adUnitId = ""
        zoneId = ""
        super.init()
    }

    func load(adConfiguration: AdConfiguration, completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
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
        interstitialAd = .init(adUnitId: APRAdMobAdUnitId(adUnitId))
        interstitialAd?.set(extras: localExtras)
        interstitialAd?.delegate = self
        interstitialAd?.load()
    }
}

extension APRAdMobInterstitialAd: GADMediationInterstitialAd {
    public func present(from viewController: UIViewController) {
        interstitialAd?.show()
    }
}

extension APRAdMobInterstitialAd: APRInterstitialAdDelegate {
    public func onAdNoBid(_ interstitialAd: AppierAds.APRInterstitialAd) {
        logger.debug("\(#function)")
    }

    public func onAdLoaded(_ interstitialAd: AppierAds.APRInterstitialAd) {
        logger.debug("\(#function)")
        self.delegate = completionHandler?(self, nil)
    }

    public func onAdLoadedFailed(
        _ interstitialAd: AppierAds.APRInterstitialAd,
        error: AppierAds.APRError
    ) {
        logger.debug("\(#function)")
        self.delegate = completionHandler?(self, error)
    }

    public func onAdShown(_ interstitialAd: AppierAds.APRInterstitialAd) {
        logger.debug("\(#function)")
    }

    public func onAdShownFailed(_ interstitialAd: AppierAds.APRInterstitialAd) {
        logger.debug("\(#function)")
    }

    public func onAdDismiss(_ interstitialAd: AppierAds.APRInterstitialAd) {
        logger.debug("\(#function)")
    }

    public func onAdClickedRecorded(
        _ interstitialAd: AppierAds.APRInterstitialAd
    ) {
        logger.debug("\(#function)")
    }
}
