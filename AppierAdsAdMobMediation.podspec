#
# Be sure to run `pod lib lint AppierAdsAdMobMediation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'version_appier_ads_admob_mediation_sdk.json')))

Pod::Spec.new do |s|
  s.name         = 'AppierAdsAdMobMediation'
  s.version      = package['version']
  s.summary      = 'Appier adapter used for mediation with the Google Mobile Ads SDK'
  s.homepage     = 'https://www.appier.com'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Appier" => "appier-ssp-dev@appier.com" }
  s.platform     = :ios, '12.0'
  s.source       = { :git => 'https://github.com/appier/appier-ads-ios.git', :tag => s.version.to_s }
  s.static_framework = true
  s.user_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  s.ios.deployment_target = '12.0'

  s.source_files = 'AppierAdsAdMobMediation/Classes/**/*'
  s.exclude_files = '**/*.plist'

  s.dependency "Google-Mobile-Ads-SDK", "~> 11.2"
  s.dependency "AppierAds", "~> 1.2.0"
end
