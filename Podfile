# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

target 'YNDetectWebBlank' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  pod 'Aspects', '1.4.1'

end

target 'YNDetectWebBlankDemo' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  pod 'YNDetectWebBlank', :path=>'./'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
        end
    end
end
