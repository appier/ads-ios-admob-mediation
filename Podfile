# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
workspace 'AppierAdsAdMobMediationWorkspace'

use_frameworks!
def pods
  pod 'Google-Mobile-Ads-SDK', '~>11.2'
  pod 'AppierAds', '1.2.1'
end

# ignore all warnings from all pods
inhibit_all_warnings!

target 'AppierAdsAdMobMediation' do
  # Pods for AppierAdsAdMobMediation
  pods
  
  project 'AppierAdsAdMobMediationSdk.xcodeproj'
end

