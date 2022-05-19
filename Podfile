# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
workspace 'AppierAdsAdMobMediationWorkspace'

use_frameworks!
def pods
  pod 'Google-Mobile-Ads-SDK', '~>9.3.0'
  pod 'AppierAds', '~>0.1.16'
end

# ignore all warnings from all pods
inhibit_all_warnings!

target 'AppierAdsAdMobMediation' do
  # Pods for AppierAdsAdMobMediation
  pods
  
  project 'AppierAdsAdMobMediationSdk/AppierAdsAdMobMediationSdk.xcodeproj'
end

