#
#  Be sure to run `pod spec lint MDCurve.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name          = "MDCurveKit"
  s.homepage      = "https://github.com/yangchenlarkin/MDCurveKit"
  s.summary       = "A resolution for curve calculation some views base on it"
  s.version       = "1.0.0"
  s.license       = "MIT"
  s.author        = { "剑川道长" => "yangchenlarkin@gmail.com" }
  s.source        = { :git => "https://github.com/yangchenlarkin/MDCurveKit.git", :tag => '1.0.0' }
  s.requires_arc  = true
  s.platform      = :ios, '6.0'
  s.source_files  = "MDCurveKit", "MDCurveKit/**/*"
end
