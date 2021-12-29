require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "RNCustomAuthSdk"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  RNCustomAuthSdk
                   DESC
  s.homepage     = "https://github.com/torusresearch/customauth-react-native-sdk"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author       = { "Torus Labs" => "hello@tor.us" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/torusresearch/customauth-react-native-sdk.git", :branch => "master" }

  s.source_files = "ios/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency 'React'
  s.dependency 'CustomAuth', '~> 2.0.0'
  #s.dependency "others"
end
