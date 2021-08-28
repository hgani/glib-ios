#
# Be sure to run `pod lib lint glib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GLib'
  s.version          = '0.9.2'
  s.summary          = 'Simplify iOS development'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Simplify iOS development
                       DESC

  s.homepage         = 'https://github.com/hgani/ganilib-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hgani' => 'hendrik.gani@gmail.com' }
  s.source           = { :git => 'https://github.com/hgani/ganilib-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'glib/Classes/**/*'
  s.resources = 'glib/Fonts/*.ttf'
  s.resource_bundles = { 'GLib' => 'glib/Fonts/*.ttf' }

  # s.resource_bundles = {
  #   'glib' => ['glib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SwiftIconFont', '~> 6.0'
  s.dependency 'SideMenu', '~> 6.0'
  s.dependency 'SnapKit', '~> 4.0'

  s.dependency 'SwiftyJSON', '4.1'
  s.dependency 'SVProgressHUD', '~> 2.2'

  # http://www.dbotha.com/2014/12/04/optional-cocoapod-dependencies/
  s.default_subspec = 'Core'

  s.subspec 'Core' do |sub|
  end

  s.subspec 'RemoteImage' do |sub|
    sub.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DINCLUDE_KINGFISHER' }
    sub.dependency 'Kingfisher', '~> 4.0'
  end

  s.subspec 'Realm' do |sub|
    sub.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DINCLUDE_REALM' }
    #sub.dependency 'RealmSwift', '~> 3.20'
    sub.dependency 'RealmSwift', '~> 10.12'
  end

  s.subspec 'Eureka' do |sub|
    sub.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DINCLUDE_EUREKA' }
    sub.dependency 'Eureka', '~> 4.3.0'
  end

  # Requires NSLocationWhenInUseUsageDescription in Info.plist
  s.subspec 'Location' do |sub|
    sub.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DINCLUDE_LOCATION' }
  end

  # Requires NSPhotoLibraryUsageDescription in Info.plist
  s.subspec 'Photo' do |sub|
    sub.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DINCLUDE_PHOTO' }
    sub.dependency 'Alamofire', '~> 4.8'
  end

  s.subspec 'Oauth' do |sub|
    sub.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DINCLUDE_OAUTH' }
    sub.dependency 'FBSDKCoreKit/Swift', '6.5.2'
    sub.dependency 'FBSDKLoginKit/Swift', '6.5.2'
  end

  # Stripe requires NSCameraUsageDescription in Info.plist
  s.subspec 'Stripe' do |sub|
    sub.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DINCLUDE_STRIPE' }
    sub.dependency 'Stripe'
  end

  s.subspec 'IAPurchase' do |sub|
    sub.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DINCLUDE_IAP' }
    sub.dependency 'SwiftyStoreKit', '~> 0.15.0'
  end

  s.subspec 'UILibs' do |sub|
    sub.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DINCLUDE_UILIBS' }
    sub.dependency 'XLPagerTabStrip', '~> 8.0'
    sub.dependency 'TTTAttributedLabel'
    #sub.dependency 'RSSelectionMenu', '~> 5.3.2'
    sub.dependency 'RSSelectionMenu', '~> 7.1.3'
    sub.dependency 'Charts', '~> 3.2.2'
  end

  s.subspec 'MDLibs' do |sub|
    sub.xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DINCLUDE_MDLIBS' }
    # sub.dependency 'MBRadioButton'
    # sub.dependency 'MBCheckboxButton'
    sub.dependency 'MBRadioCheckboxButton2', '2.0.1'
    sub.dependency 'RxSwift', '~> 4.5'
    sub.dependency 'MaterialComponents/Buttons', '124.1.1'
    sub.dependency 'MaterialComponents/Buttons+Theming', '124.1.1'
    sub.dependency 'MaterialComponents/TextFields', '124.1.1'
    sub.dependency 'MaterialComponents/Tabs', '124.1.1'
    sub.dependency 'MaterialComponents/ProgressView', '124.1.1'
    sub.dependency 'MaterialComponents/Snackbar', '124.1.1'
    sub.dependency 'MaterialComponents/Dialogs', '124.1.1'
    sub.dependency 'MaterialComponents/Cards', '124.1.1'
    sub.dependency 'MaterialComponents/Cards+Theming', '124.1.1'
    sub.dependency 'MaterialComponents/List', '124.1.1'
    sub.dependency 'MaterialComponents/ActionSheet', '124.1.1'
    sub.dependency 'MaterialComponents/Chips', '124.1.1'
    sub.dependency 'MaterialComponents/TextControls+FilledTextAreas', '124.1.1'
    sub.dependency 'MaterialComponents/TextControls+FilledTextAreasTheming', '124.1.1'
    sub.dependency 'MaterialComponents/TextControls+FilledTextFields', '124.1.1'
    sub.dependency 'MaterialComponents/TextControls+FilledTextFieldsTheming', '124.1.1'
    sub.dependency 'MaterialComponents/TextControls+OutlinedTextAreas', '124.1.1'
    sub.dependency 'MaterialComponents/TextControls+OutlinedTextAreasTheming', '124.1.1'
    sub.dependency 'MaterialComponents/TextControls+OutlinedTextFields', '124.1.1'
    sub.dependency 'MaterialComponents/TextControls+OutlinedTextFieldsTheming', '124.1.1'

    # Need to lock this because v3.0.0 produces errors during archiving.
    sub.dependency 'MDFInternationalization', '2.0.0'
    
    # sub.dependency 'MaterialComponents/TextFields+Theming', '~> 92.0'
    # sub.dependency 'MaterialComponents/schemes/Shape', '~> 92.0'
    sub.dependency 'MarkdownKit', '1.5'
    sub.dependency 'FlexLayout'
    sub.dependency 'jsonlogic', '~> 1.1.0'
    
    # TODO
    # TODO: Move this out to a separate subspec
    sub.dependency 'SwiftPhoenixClient'
  end
end
