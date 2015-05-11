Pod::Spec.new do |s|
  s.name             = "pixlee-ios-sdk"
  s.version          = "0.1.1"
  s.summary          = "A native Objective-C wrapper for the Pixlee album API."
  s.description      = <<-DESC
                       This SDK makes it easy for Pixlee customers to easily include Pixlee albums in their native iOS apps. It includes a native wrapper to the Pixlee album API as well as some drop-in and customizable UI elements to quickly get you started.
                       DESC
  s.homepage         = "httpshttps://github.com/pixlee/pixlee-ios"
  s.license          = 'MIT'
  s.author           = { "Awad Sayeed" => "awad@pixleeteam.com" }
  s.source           = { :git => "https://github.com/pixlee/pixlee-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'pixlee-ios-sdk' => ['Pod/Assets/*.png']
  }
  s.dependency 'AFNetworking', '~> 2.5.3'
  s.dependency 'Masonry', '~> 0.6.1'
  s.dependency 'SDWebImage', '~> 3.7.2'
  s.dependency 'FormatterKit/TimeIntervalFormatter', '~> 1.8.0'
end