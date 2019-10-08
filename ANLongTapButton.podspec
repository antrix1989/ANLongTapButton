#
# Be sure to run `pod lib lint ANLongTapButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ANLongTapButton"
  s.version          = "5.0.0"
  s.summary          = "Long tap button with animated progress bar."
  s.homepage         = "https://github.com/antrix1989/ANLongTapButton"
  s.license          = 'MIT'
  s.author           = { "Sergey Demchenko" => "antrix1989@gmail.com" }
  s.source           = { :git => "https://github.com/antrix1989/ANLongTapButton.git", :tag => s.version.to_s }
  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ANLongTapButton' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'UIKit'
end
