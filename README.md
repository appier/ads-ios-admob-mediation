# Appier Mediation for AdMob and Google Ad Manager iOS SDK

This is Appier's official iOS mediation adapter for the Google Mobile Ads (GMA) SDK. It supports both **AdMob** mediation and **Google Ad Manager (GAM)** mediation — the same adapter, the same class name, the same server parameter schema. The latest documentation can be found [here](https://docs.aps.appier.com/docs/admob-mediation-sdk-ios).

Refer to [ads-ios-sample-swift](https://github.com/appier/ads-ios-sample-swift) for sample integrations.

## Prerequisites

- Google Mobile Ads SDK `~> 12.4`
- AppierAds iOS SDK `~> 2.1`
- iOS deployment target >= `12.0`
- Configure the mediation line item on your Google dashboard:
  - `Class Name`: `AppierAdsAdMobMediation.APRAdAdapter`
  - `Parameter`: `{ "zoneId": "<your_zone_id_from_appier>" }`

  The same values work on both AdMob and Ad Manager — see [Google Ad Manager (GAM)](#google-ad-manager-gam) for the Ad Manager setup.

## Installation

### Swift Package Manager

In Xcode, go to **File › Add Package Dependencies** and enter:

```
https://github.com/appier/ads-ios-admob-mediation
```

Also add the following packages separately:
- [Google Mobile Ads SDK](https://github.com/googleads/swift-package-manager-google-mobile-ads) (`~> 12.4`)
- [AppierAds SDK](https://github.com/appier/ads-ios-sdk) (`~> 2.1`)

Then add `-ObjC` to your app target's **Build Settings › Other Linker Flags**. The adapter ships as a static library and GMA only looks it up by its class name, so nothing in your code references it; without `-ObjC` the linker can drop it and GMA never calls the Appier adapter. CocoaPods adds this flag for you.

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'AppierAdsAdMobMediation', '~> 2.1'
pod 'AppierAds', '~> 2.1'
pod 'Google-Mobile-Ads-SDK', '~> 12.4'
```

## Initialize the Ads SDK

Before loading ads, call the `start`: method on the `APRAds.shared`, which initializes the SDK and calls back a completion handler once initialization is complete. This only needs to be done once, ideally at app launch and before initializing AdMob Ads SDK.

Here's an example of how to call the `start` method in your `AppDelegate`:

``` swift
import AppierAds
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
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
      	// We provide advertiser image for user to get our advertising policy.
				(nativeAdView.advertiserView as? UIImageView)?.image = nativeAd.extraAssets?[APRAdMobMediation.shared.advertiserIcon] as? UIImage

        // Get additional information from APRAdExtras.
        let sampleAppInfo = nativeAd.extraAssets?[APRAdMobMediation.shared.appInfo] as? SampleAppInfo
      
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

## Google Ad Manager (GAM)

Ad Manager and AdMob are served by the same Google Mobile Ads SDK, and GMA hands both of them to the same Appier adapter class. Nothing about the adapter changes: `AppierAdsAdMobMediation.APRAdAdapter` is still the class you configure, `APRAdExtras` is still how you pass local extras, and `APRAdMobAdEventDelegate` still reports impressions and clicks. Only the dashboard setup and the request you build in the app differ.

### 1. Configure the custom event in Ad Manager

In Ad Manager, Appier is added as a **yield partner** whose integration type is **custom event**, inside a yield group targeting your native inventory (**Delivery › Yield groups › New yield group**, format `Native`). Ad Manager's exact menu labels move between releases; what matters is the three fields on the custom event:

| Field | Value |
| --- | --- |
| `Class Name` | `AppierAdsAdMobMediation.APRAdAdapter` |
| `Parameter` | `{"adUnitId":"<your_ad_unit_id>","zoneId":"<your_zone_id_from_appier>"}` |
| `Label` | Anything that identifies the placement to you |

`Class Name` is platform-specific: the value above is the iOS one (Swift module name + class name). Entering the Android class name on an iOS line item is not an error Ad Manager reports — GMA simply fails to find the adapter and falls through to the next network, so Appier ads never appear.

The server parameter is exactly the same shape as on AdMob — the adapter cannot tell the two platforms apart, and does not need to.

### 2. Use a separate Appier zone ID for GAM

`zoneId` is the only placement identifier the adapter sends to the Appier ad server, so **it is also the only thing that can distinguish GAM traffic from AdMob traffic**. If you need the two reported separately, ask Appier for a dedicated zone for your Ad Manager inventory and use it in the GAM `Parameter` only.

Reusing one zone across both platforms is supported, but the traffic is then indistinguishable server-side and cannot be split apart afterwards.

### 3. Build the request in your app

Use `AdManagerAdRequest` and your Ad Manager ad unit path (`/<network-code>/<ad-unit>`) instead of the AdMob ad unit ID. Registering `APRAdExtras` is identical:

``` swift
import AppierAds
import GoogleMobileAds
import AppierAdsAdMobMediation

// Set localExtras — same as AdMob
let appierExtras = APRAdExtras()
appierExtras.set(key: .adUnitId, value: "<your_ad_unit_id>")
appierExtras.set(key: .appInfo, value: SampleAppInfo())

// Build request against the Ad Manager ad unit path
let adLoader = AdLoader(
    adUnitID: "/<network-code>/<ad-unit>",
    rootViewController: self,
    adTypes: [.native],
    options: nil)

// Load Ad — AdManagerAdRequest, not AdRequest
let request = AdManagerAdRequest()
request.register(appierExtras)
adLoader.load(request)
```

Everything from the `adLoader(_:didReceive:)` callback onward — detecting an Appier ad through `advertiser`, reading `extraAssets`, registering `APRAdMobAdManager.shared.eventDelegate` — is the same as the AdMob integration above.

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
