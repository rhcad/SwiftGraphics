Pod::Spec.new do |s|

  s.name         = 'SwiftGraphics'
  s.version      = '0.0.1'
  s.summary      = 'Bringing Swift goodness to Quartz.'
  s.homepage     = 'https://github.com/schwa/SwiftGraphics'
  s.license      = { :type => 'BSD', :file => 'LICENSE' }
  s.author       = { 'Jonathan Wight' => 'schwa@toxicsoftware.com' }
  s.social_media_url = 'https://twitter.com/schwa'
  s.source       = { :git => 'https://github.com/rhcad/SwiftGraphics.git', :branch => 'xcode61' }

  s.requires_arc = true
  s.subspec 'Core' do |cs|
    cs.source_files = 'SwiftGraphics/*.{h,m,mm,swift}'
    cs.ios.deployment_target = '8.0'
    cs.osx.deployment_target = '10.9'
    cs.frameworks = "CoreGraphics", "Foundation"
  end
  s.subspec 'iOS' do |is|
    is.platform = 'ios'
    is.ios.deployment_target = '8.0'
    is.source_files = 'SwiftGraphics_iOS/*.{h,m,swift}'
    is.dependency 'SwiftGraphics/Core'
    is.frameworks = "UIKit"
  end
  s.subspec 'OSX' do |xs|
    xs.platform = 'osx'
    xs.osx.deployment_target = '10.9'
    xs.source_files = 'SwiftGraphics_OSX/*.{h,m,swift}'
    xs.dependency 'SwiftGraphics/Core'
    xs.frameworks = "AppKit"
  end
end
