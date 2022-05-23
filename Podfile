# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
workspace 'AppierAdsAdMobMediationWorkspace'

use_frameworks!
def pods
  pod 'Google-Mobile-Ads-SDK', '~>9.3.0'
  pod 'AppierAds', '~>1.0.0'
end

# ignore all warnings from all pods
inhibit_all_warnings!

target 'AppierAdsAdMobMediation' do
  # Pods for AppierAdsAdMobMediation
  pods
  
  project 'AppierAdsAdMobMediationSdk/AppierAdsAdMobMediationSdk.xcodeproj'
end

