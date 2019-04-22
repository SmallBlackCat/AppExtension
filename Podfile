source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!
#Framework

install! 'cocoapods', :deterministic_uuids => false

def baseCore
  pod 'Validation', :path => 'BaseSupport/Validation'
  pod 'Encryption', :path => 'BaseSupport/Encryption'
  pod 'FunctionalSwift', :path => 'BaseSupport/FunctionalSwift'
  pod 'CocoaExtension', :path => 'BaseSupport/CocoaExtension'
  pod 'ModalManager', :path => 'BaseSupport/ModalManager'
end
def rx
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
  pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
end
def rxExtension
  rx
  pod 'RxGesture', :git => 'BaseSupport/RxGesture'
  pod 'RxSwiftExt', :git => 'BaseSupport/RxSwiftExt'
  pod 'RxOptional', :git => 'BaseSupport/RxOptional'
  #    pod 'RxAnimated'
  #    pod 'RxKeyboard'
end
def snapKit
  pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'
end

target:'Core' do
  baseCore
end
target:'Coordinator' do
  baseCore
end
target:'AnimatedTransition' do
  baseCore
end
target:'UserNotificationManager' do
  baseCore
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
end
target:'List' do
  baseCore
  rx
  pod 'DifferenceKit'
end
target:'UIComponents' do
  baseCore
  rx
  snapKit
  target:'ScrollExtensions' do
  end
  target:'CollectionKitExtensions' do
    pod 'CollectionKit', :git => 'https://github.com/SoySauceLab/CollectionKit'
  end
end
target:'EmptyDataSet' do
  baseCore
  rx
  snapKit
end
target:'RxExtensions' do
  baseCore
  rxExtension
end
target:'NavigationFlow' do
  baseCore
  rxExtension
end

def commonPods
  baseCore
  rxExtension
  snapKit
  
  pod 'SwiftLint'
  
  pod 'Alamofire'
  
  pod 'Kingfisher'
  pod 'MBProgressHUD'
  pod 'SwiftyUserDefaults'
  
  pod 'Hero' #仅测试
  pod 'CollectionKit', :git => 'https://github.com/SoySauceLab/CollectionKit'  #仅测试
  
  pod 'MJRefresh'
  pod 'DifferenceKit'
end

target:'ProjectBasic' do
  commonPods
  pod 'Alamofire'
  
  pod 'Kingfisher'
  pod 'MBProgressHUD'
  pod 'SwiftyUserDefaults'
  pod 'ReSwift'
end

target:'AppExtension' do
  commonPods
  pod 'ReSwift'
  target 'AppExtensionUITests' do
    inherit! :search_paths
  end
  target 'AppExtensionTests' do
    inherit! :search_paths
  end
end


