require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-tencent-im"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.license      = package["license"]
  s.authors      = package["author"]
  s.homepage     = "https://github.com/kzyman/react-native-tencent-im"  
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/kzyman/react-native-tencent-im.git", :tag => "#{s.version}"}
  s.source_files = "ios/**/*.{h,m,mm,swift}"

  s.static_framework = true
  s.swift_version = "4.0"
  s.dependency "React"
  s.dependency "TXIMSDK_iOS", "5.1.10"
end
