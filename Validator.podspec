#
# Be sure to run `pod lib lint swift-text-validator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "swift-text-validator"
  s.version          = "0.1.1"
  s.summary          = "A Swift text input validator that uses NSNotificationCenter"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
                        A Swift text input validator that uses NSNotificationCenter. ValidatedTextFields and ValidatedTextViews are UITextFields and UITextViews that follow the CanValidateInput protocol. Validation types are set using objc-enabled enums to provide cross-compatibility. The validation requirements can be set in the form of regex for password and email and long zip codes can be specified. For validating names, there is no default and the regex must be provided by the developer. To specify what happens to the view when text input begins, changes, or ends, the developer must also provide the callback in the validateText signature.
                       DESC

  s.homepage         = "https://github.com/jen-l/swift-text-validator"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jenelle Walker" => "jen.mwlkr@gmail.com" }
  s.source           = { :git => "https://github.com/jen-l/swift-text-validator.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/jen_ll_'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'Validator' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
