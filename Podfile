# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

#pre_install do |installer|
#  # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
#  Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
#end

target 'AskMe' do
  use_frameworks!

  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase'
  pod 'JSQMessagesViewController'
  pod 'GoogleSignIn'
  pod 'SDWebImage'
  
  pod 'GeoFire', :git => 'https://github.com/firebase/geofire-objc.git'
  pod 'SCRecorder'

  pod 'PubNub', '~>4.0'
end
