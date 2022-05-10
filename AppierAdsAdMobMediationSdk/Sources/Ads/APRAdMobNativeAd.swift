import AppierAds
import GoogleMobileAds

@objc public class APRAdMobNativeAd: NSObject {
    private var nativeAd: APRNativeAd?
    private var mediationDelegate: GADMediationNativeAdEventDelegate?
    private var completionHandler: GADMediationNativeLoadCompletionHandler?
    
    override init() {
        super.init()
    }
    
    func load(adConfiguration: AdConfiguration, completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
        let localExtras = adConfiguration.getLocalExtras()
        guard let adUnitId = localExtras.get(key: .adUnitId) as? String else {
            mediationDelegate = completionHandler(self, APRError(type: .adUnitIdError))
            return
        }

        self.completionHandler = completionHandler
        nativeAd = .init(adUnitId: APRAdMobAdUnitId(adUnitId))
        nativeAd?.set(extras: localExtras)
        nativeAd?.delegate = self
        nativeAd?.loadAd()
    }
}

extension APRAdMobNativeAd: GADMediationNativeAd {
    
    @objc public var headline: String? {
        return nativeAd?.title
    }

    @objc public var images: [GADNativeAdImage]? {
        guard let nativeAd = nativeAd else {
            return .none
        }
        var imgs: [GADNativeAdImage] = []
        if let mainImage = nativeAd.mainImage {
            imgs.append(.init(image: mainImage))
        }
        return imgs
    }

    @objc public var body: String? {
        return nativeAd?.mainText
    }

    @objc public var icon: GADNativeAdImage? {
        if let image = nativeAd?.iconImage {
            return .init(image: image)
        }
        return .none
    }

    @objc public var callToAction: String? {
        return nativeAd?.callToAction
    }

    @objc public var starRating: NSDecimalNumber? {
        return nil
    }

    @objc public var store: String? {
        return nil
    }

    @objc public var price: String? {
        return nil
    }

    @objc public var advertiser: String? {
        return APRAdMobMediation.shared.advertiserName
    }

    @objc public var extraAssets: [String : Any]? {
        guard let nativeAd = nativeAd else {
            return .none
        }
        var assets: [String: Any] = [:]
        if let privacyInformationImage = nativeAd.privacyInformationImage {
            assets[APRAdMobMediation.shared.advertiserIcon] = privacyInformationImage
        }
        return assets
    }
    
    public func handlesUserImpressions() -> Bool {
        return false
    }
    
    public func handlesUserClicks() -> Bool {
        return false
    }

    @objc public func didRecordImpression() {
        logger.debug("\(#function)")
        nativeAd?.recordImpression()
    }
    
    public func didRecordClickOnAsset(withName assetName: GADNativeAssetIdentifier, view: UIView, viewController: UIViewController) {
        logger.debug("\(#function)")
        if assetName == .advertiserAsset {
            nativeAd?.clickPrivacyInformationView()
        } else {
            nativeAd?.clickAdView()
        }
    }
    
    public func didUntrackView(_ view: UIView?) {
        logger.debug("\(#function)")
        nativeAd?.untrackAdView()
    }
}

extension APRAdMobNativeAd: NativeAdDelegate {
    @objc public func onAdLoaded(nativeAd: APRNativeAd) {
        logger.debug("\(#function)")
        self.mediationDelegate = self.completionHandler?(self, nil)
    }
    
    @objc public func onAdLoadedFailed(nativeAd: APRNativeAd, error: APRError) {
        logger.debug("\(#function)")
        self.mediationDelegate = self.completionHandler?(self, error)
    }
    
    @objc public func onAdImpressionRecorded(nativeAd: APRNativeAd) {
        logger.debug("\(#function)")
        mediationDelegate?.reportImpression()
    }
    
    @objc public func onAdImpressionRecordedFailed(nativeAd: APRNativeAd, error: APRError) {
        logger.debug("\(#function)")
    }
    
    @objc public func onAdClickedRecorded(nativeAd: APRNativeAd) {
        logger.debug("\(#function)")
        mediationDelegate?.reportClick()
    }

    @objc public func onAdClickedRecordedFailed(nativeAd: APRNativeAd, error: APRError) {
        logger.debug("\(#function)")
    }
}
