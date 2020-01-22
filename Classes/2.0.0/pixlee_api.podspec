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

  spec.name         = "pixlee_api"
  spec.version      = "2.0.0"
  spec.summary      = "An API Wrapper for Pixlee API"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

    spec.description      = <<-DESC
  TODO: Add long description of the pod here.
                         DESC

    spec.homepage         = 'https://github.com/csacsi/ios-sdk-carthage'
    # spec.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    spec.license          = { :type => 'MIT', :file => 'LICENSE' }
    spec.author           = { 'pixlee-accounts' => 'rachidi29@gmail.com' }
    spec.source           = { :git => 'https://github.com/csacsi/ios-sdk-carthage.git', :tag => spec.version.to_s}

    spec.ios.deployment_target = '12.0'

    spec.source_files = 'pixlee_api/**/*{swift}'
    
    spec.resources = "pixlee_api/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

    # spec.public_header_files = 'Pod/Classes/**/*.h'
    # spec.frameworks = 'UIKit', 'MapKit'
     spec.dependency 'Alamofire', '~> 5.0.0-rc.3'
end
