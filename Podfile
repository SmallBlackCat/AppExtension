source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
#Framework

install! 'cocoapods', :deterministic_uuids => false

abstract_target 'BaseCore' do
    pod 'Validation', :path => '~/Desktop/wallet-ios/BaseSupport/Validation'
    pod 'Encryption', :path => '~/Desktop/wallet-ios/BaseSupport/Encryption'
    pod 'FunctionalSwift', :path => '~/Desktop/wallet-ios/BaseSupport/FunctionalSwift'
    pod 'CocoaExtension', :path => '~/Desktop/wallet-ios/BaseSupport/CocoaExtension'
    pod 'ModalManager', :path => '~/Desktop/wallet-ios/BaseSupport/ModalManager'
    
    target:'Core' do
    end
    target:'Coordinator' do
    end
    target:'AnimatedTransition' do
    end
    target:'UserNotificationManager' do
        pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
    end
    target:'List' do
        pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'DifferenceKit'
    end
    target:'UIComponents' do
        pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'
        target:'ScrollExtensions' do
        end
        target:'CollectionKitExtensions' do
            pod 'CollectionKit', :git => 'https://github.com/SoySauceLab/CollectionKit'
        end
    end
    target:'EmptyDataSet' do
        pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'
        pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
    end

    abstract_target 'CommonPods' do
        pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'RxGesture'
        pod 'RxSwiftExt'
        pod 'RxAnimated'
        pod 'RxOptional'
        pod 'RxKeyboard'

        pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'

        pod 'SwiftLint'

        pod 'Alamofire'

        pod 'Rx+Kingfisher', :path => '~/Desktop/wallet-ios/BaseSupport/RxKingfisher'
        pod 'Kingfisher'
        pod 'MBProgressHUD'
        pod 'SwiftyUserDefaults'
        
        pod 'MJRefresh', :git => 'https://github.com/CoderMJLee/MJRefresh'
        pod 'DifferenceKit'

        target:'RxExtensions' do
        end
        target:'NavigationFlow' do
        end
        target:'ProjectBasic' do
            pod 'Alamofire'
            pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'

            pod 'Rx+Kingfisher', :path => '~/Desktop/wallet-ios/BaseSupport/RxKingfisher'
            pod 'Kingfisher'
            pod 'MBProgressHUD'
            pod 'SwiftyUserDefaults'

        end

        target:'AppExtension' do
            target 'AppExtensionUITests' do
                inherit! :search_paths
            end
            target 'AppExtensionTests' do
                inherit! :search_paths
            end
        end
    end
end



post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
