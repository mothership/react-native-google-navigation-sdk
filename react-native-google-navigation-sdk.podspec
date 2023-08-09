Pod::Spec.new do |s|
  s.name         = "react-native-google-navigation-sdk"
  s.version      = "0.1.0"
  s.summary      = "React Native wrapper for Google Nav sdk"
  s.homepage     = "https://github.com/mothership/react-native-google-navigation-sdk#readme"
  s.license      = "MIT"
  s.authors      = "Mothership <raul@mothership.com> (https://github.com/mothership)"

  s.platforms    = { :ios => "14.0" }
  s.source       = { :git => "https://github.com/mothership/react-native-google-navigation-sdk.git" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"

  s.dependency "React-Core"

  s.dependency "GoogleMaps", "8.1.0"
  s.dependency "GoogleNavigation", "5.1.0"

end
