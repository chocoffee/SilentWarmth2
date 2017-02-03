# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SilentWarmth' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SilentWarmthi
  pod 'SCLAlertView' , :git => 'https://github.com/vikmeup/SCLAlertView-Swift.git', :branch => 'master', :submodules => true
  pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git', :branch => 'master' , :submodules => true
  pod 'ZFRippleButton', :git => 'https://github.com/zoonooz/ZFRippleButton.git', :tag => '0.6'
  #pod 'Minamo'  
target 'SilentWarmthTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SilentWarmthUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
  end
end
