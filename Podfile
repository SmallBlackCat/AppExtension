source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!
#Framework

install! 'cocoapods', deterministic_uuids: false, generate_multiple_pod_projects: true

def userPod (name)
  pod name, :path => "BaseSupport/#{name}"
end
def userForkPod (name)
  pod name, :path => "BaseSupport/Fork/#{name}"
end

def baseCorePod
  userPod 'Validation'
  userPod 'Encryption'
  userPod 'FunctionalSwift'
  userPod 'CocoaExtension'
  userPod 'ModalManager'
  userPod 'RxNetwork'
end

def collectionKitPod
  userForkPod 'CollectionKit'
end

def alamofirePod
  pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire'
end

def rxPod (hasCocoa = true)
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
  if hasCocoa
    pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
  end
end

def rxExtensionPod
  rxPod
  userForkPod 'RxGesture'
  userForkPod 'RxSwiftExt'
  userForkPod 'RxOptional'
  #    pod 'RxAnimated'
  #    pod 'RxKeyboard'
end

def snapKitPod
  pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'
end

target:'Core' do
  baseCorePod
end
target:'Coordinator' do
  baseCorePod
end
target:'AnimatedTransition' do
  baseCorePod
end
target:'UserNotificationManager' do
  baseCorePod
  rxPod hasCocoa = false
end
target:'List' do
  baseCorePod
end
target:'UIComponents' do
  baseCorePod
  rxPod
  snapKitPod
  target:'ScrollExtensions' do
  end
  target:'CollectionKitExtensions' do
    collectionKitPod
  end
end
target:'EmptyDataSet' do
  baseCorePod
  rxPod
  snapKitPod
end
target:'RxExtensions' do
  baseCorePod
  rxExtensionPod
end
target:'NavigationFlow' do
  baseCorePod
  rxExtensionPod
end

def commonPods
  baseCorePod
  rxExtensionPod
  snapKitPod
  
  pod 'SwiftLint'
  
  alamofirePod
  
  pod 'Kingfisher'
  pod 'MBProgressHUD'
  userForkPod 'SwiftyUserDefaults'
  
  pod 'Motion'
  collectionKitPod #仅测试
  
  pod 'MJRefresh'
  pod 'DifferenceKit'
end

def projectBasicPod
  commonPods
  alamofirePod
  
  pod 'Kingfisher'
  pod 'MBProgressHUD'
  pod 'ReSwift', :git => 'https://github.com/ReSwift/ReSwift.git'
end
target:'ProjectBasic' do
  projectBasicPod
end

target:'AppExtension' do
  projectBasicPod
  target 'AppExtensionUITests'
  target 'AppExtensionTests'
end


