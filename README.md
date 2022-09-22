# Appier Meidation for AdMob iOS SDK

This is Appier's official iOS mediation repository for AdMob SDK. The latest updated documentation can be found [here](https://docs.aps.appier.com/docs/admob-mediation-sdk-ios).

Refer to [ads-ios-sample-swift](https://github.com/appier/ads-ios-sample-swift) for sample integrations.


## Prerequisites

- Make sure you are using AdMob iOS SDK version >= `9.3.0`, < `10.0.0`
- Make sure your project's iOS target version >= `12.0`
- Make sure you have already configured line items on AdMob Web UI
	- `Class Name` field should be `AppierAdsAdMobMediation.APRAdAdapter`
	- `Parameter` field should follow the format `{ "zoneId": "<your_zone_id_from_appier>" }`

## Installation

### CocoaPods

To integrate `AppierAdsAdMobMediation` into your Xcode project using CocoaPods, specify the frameworks in your `Podfile`
``` ruby
pod 'AppierAdsAdMobMediation', '1.2.0'
pod 'AppierAds', '1.1.2'
pod 'Google-Mobile-Ads-SDK', '9.5.0'
```

## Initialize the Ads SDK

Before loading ads, call the `start`: method on the `APRAds.shared`, which initializes the SDK and calls back a completion handler once initialization is complete. This only needs to be done once, ideally at app launch and before initializing AdMob Ads SDK.

Here's an example of how to call the `start` method in your `AppDelegate`:

``` swift
import AppierAds
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  	@Override
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // ...
      	APRAds.shared.start(completion: nil)
      	// ...
      	GADMobileAds.sharedInstance().start(completionHandler: nil)
      	// ...
    }
}
```

## Prepare for iOS 14+

### Enable SKAdNetwork to track conversions

The Appier Ads SDK supports conversion tracking using Apple's `SKAdNetwork`, which lets Appier attribute an app install even the IDFA is not available.

To enable this functionality, update the `SKAdNetworkItems` key with an additional dictionary that defines Appier `SKAdNetworkIdentifier` values in your `Info.plist`.

The snippet below includes Appier(`x8uqf25wch.skadnetwork`, `v72qych5uu.skadnetwork`) identifiers.

``` xml
<key>SKAdNetworkItems</key>
  <array>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>x8uqf25wch.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>v72qych5uu.skadnetwork</string>
    </dict>
  </array>
```

### Request App Tracking Transparency authorization

To display the App Tracking Transparency authorization request for accessing the IDFA, update your `Info.plist` to add the `NSUserTrackingUsageDescription` key with a custom message describing your usage. Here is an example description text:

``` xml
<key>NSUserTrackingUsageDescription</key>
	<string>The identifier will be used to deliver personalized ads to you.</string>
```

To present App Tracking Transparency dialog, call `requestTrackingAuthorization`. We recommend waiting for the completion callback prior to loading ads so that if the user grants the permission, the Appier Ads SDK can use the IDFA in ad requests.

Here's an example of how to call the `requestTrackingAuthorization` method in your `AppDelegate`:

``` swift
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  	func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
}
```

## GDPR Consent (Recommended)

In consent to GDPR, we strongly suggest the consent status to our SDK via `APRAds.shared.configuration.gdprApplies` so that we will track user's personal information. Without this configuration, Appier will `NOT` apply GDPR by default. Note that this will impact advertising performance thus impacting revenue.

This only needs to be done once, ideally at app launch and before initializing Appier Ads SDK.

``` swift
import AppierAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  	@Override
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
      	// ...
      	APRAds.shared.configuration.gdprApplies = true
        // ...
      	APRAds.shared.start(completion: nil)
      	// ...
    }
}
```

## Ad Format Integration

### Native Ads Integration

To render Appier's native ads via AdMob mediation, you need to provide `<your_ad_unit_id_from_admob>` and `<your_zone_id_from_appier>`. You can either pass through `localExtras` or `serverExtras`.
Also, if you want to append any information of ad, you can pass it through `localExtras` and you will receive the information when events callback.

``` swift
import AppierAds
import GoogleMobileAds
import AppierAdsAdMobMediation


// Set localExtras
let appierExtras = APRAdExtras()
appierExtras.set(key: .adUnitId, value: "<your_ad_unit_id_from_admob>")
appierExtras.set(key: .appInfo, value: SampleAppInfo())  // pass additional information

// Build Request
let adLoader = GADAdLoader(
	  adUnitID: "<your_ad_unit_id_from_admob>",
  	rootViewController: self,
  	adTypes: [.native],
  	options: nil)

// Load Ad
let request = GADRequest()
request.register(appierExtras)
adLoader.load(request)
```

AdMob provides the delegate function `adLoader` to handle native ad. You should create an `GADNativeAdView` to render Appier Native ad. You can get more details on the [Native Ads Advanced](https://developers.google.com/admob/ios/native/advanced)

The `adLoader` sets the text, images and the native ad, etc into the ad view. You can specify Appier native view through the variable `advertiser` of AdMob native ad.

``` swift
import GoogleMobileAds
import AppierAdsAdMobMediation

func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
  	// ...	
    nativeAd.delegate = self
  
		// when the advertiser name is `Appier`, the ad is provided by Appier.
  	if let advertiser = nativeAd.advertiser, advertiser == APRAdMobMediation.shared.advertiserName {
      	// We provide advertiser image for user to get our advertising ploicy.
				(nativeAdView.advertiserView as? UIImageView)?.image = nativeAd.extraAssets?[APRAdMobMediation.shared.advertiserIcon] as? UIImage

        // Get additional information from APRAdExtras.
        let sampleAppInfo = nativeAd.extrasAssets?[APRAdMobMediation.shared.appInfo] as? SampleAppInfo
      
      	// ...
	      (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
	      (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
      	(nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
      	(nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
      
        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
    }
}
```

Appier provides `APRAdMobAdEventDelegate` to allow Apps to receive notifications after impression/click events are recorded by AppierSDK.

``` swift
class AdMobNativeViewController: UIViewController, APRAdMobAdEventDelegate {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APRAdMobAdManager.shared.eventDelegate = self  // Register APRAdMobAdEventDelegate
    }

    func onNativeAdImpressionRecorded(nativeAd: APRAdMobNativeAd) {
        APRLogger.controller.debug("adunit id: \(nativeAd.adUnitId)")  // Get ad unit id
        APRLogger.controller.debug("zone id: \(nativeAd.zoneId)")  // Get zone id
        
        let sampleAppInfo = nativeAd.appInfo as? SampleAppInfo // Get additional information from APRAdExtras
    }
    
    func onNativeAdImpressionRecordedFailed(nativeAd: APRAdMobNativeAd, error: APRError) {}
    
    func onNativeAdClickedRecorded(nativeAd: APRAdMobNativeAd) {}
    
    func onNativeAdClickedRecordedFailed(nativeAd: APRAdMobNativeAd, error: APRError) {}
}
```

## Enabling Test Ads

After integrate with Appier Ads SDK, you can test the ads display correctly via **APRAds.shared.configuration.testMode**. Without this configuration, Appier would consider the ad is ready for bidding by default.

``` swift
APRAds.shared.configuration.testMode = .bid // Always display test ads.

APRAds.shared.configuration.testMode = .noBid // Always no bid.

APRAds.shared.configuration.testMode = .bidWithStoreView // Always display store view ads if the device supports.

//...

// Initialize Appier Ads SDK
APRAds.shared.start(completion: nil)
```
