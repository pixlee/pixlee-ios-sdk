#
# Be sure to run `pod lib lint pixlee_api.podspec' to ensure this is a
# valid spec before submitting.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "PixleeSDK"
  spec.version      = "2.0.0"
  spec.summary      = "An API Wrapper for Pixlee API"

    spec.description      = <<-DESC
  TODO: Add long description of the pod here.
                         DESC

    spec.homepage         = 'https://github.com/pixlee/pixlee-ios-sdk.git'
    spec.license          = { :type => 'MIT', :file => 'LICENSE' }
    spec.author           = { 'Sungjun Hong' => 'sungjun@pixleeteam.com' }
    spec.source           = { :git => 'https://github.com/pixlee/pixlee-ios-sdk.git', :tag => spec.version.to_s}

    spec.ios.deployment_target = '12.0'
    spec.swift_version = '5.0'

    spec.source_files = 'Classes/**/*{swift}'
    
    spec.resources = "Classes/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
    spec.dependency 'Alamofire', '~> 5.0.0-rc.3'
end