#
# Be sure to run `pod lib lint MonlixOfferwall.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MonlixOfferWall'
  s.version          = '0.0.1'
  s.summary          = 'Offerwall for iOS games and apps monetization.'
  s.swift_version    = '4.0'
  
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Monlix Offerwall is an ad unit providing offers, surveys and tasks in an offerwall style for Android, iOS and Website publishers looking to monetize with rewarding opportunities for their users.
                       DESC

  s.homepage         = 'https://monlix.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'miskoajkula' => 'cofilicavujovic@gmail.com' }
  s.source           = { :git => 'https://github.com/monlix/ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'MonlixOfferwall/Classes/**/*'
end
