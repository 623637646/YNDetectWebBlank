# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'
inhibit_all_warnings!

target 'YNDetectWebBlank' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  pod 'Aspects', '1.4.1'
  pod 'KVOController', '1.2.0'

end

target 'YNDetectWebBlankDemo' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  pod 'YNDetectWebBlank', :path=>'./'
  pod 'MBProgressHUD'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
      end
    end
  end
end
