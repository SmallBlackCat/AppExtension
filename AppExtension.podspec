Pod::Spec.new do |s|
    s.name             = "AppExtension"
    s.version          = "0.0.1"
    s.summary          = "App框架"
    s.description      = <<-DESC
    App框架
    DESC
    s.homepage         = "https://github.com/Z-JaDe"
    s.license          = 'MIT'
    s.author           = { "ZJaDe" => "zjade@outlook.com" }
    s.source           = { :git => "https://github.com/Z-JaDe/AppExtension.git"}
    
    s.requires_arc          = true
    
    s.ios.deployment_target = '9.0'
    
    s.default_subspec = "Codable", "Core", "Animater", "Custom", "Third", "List"

    s.xcconfig = { 'OTHER_SWIFT_FLAGS' => '"-D" "AppExtensionPods"' }
    #基础 子模块

    s.subspec "Codable" do |ss|
        ss.source_files  = "Sources/Codable/**/*.{swift}"
    end

    s.subspec "Core" do |ss|
        ss.source_files  = "Sources/Core/**/*.{swift}"

        ss.dependency "CocoaExtension"
        ss.dependency "Encryption"
        ss.dependency "FunctionalSwift"
        ss.dependency "Validation"
        ss.dependency "ModalManager"
    end
    
    s.subspec "Animater" do |ss|
        ss.source_files  = "Sources/Animater/**/*.{swift}"
    end
    
    s.subspec "Custom" do |ss|
        ss.source_files  = "Sources/Custom/**/*.{swift,h,m}"
        ss.resource = "Sources/Custom/**/*.{bundle}"
        ss.public_header_files = "Sources/Custom/Details/WeakProxy/WeakProxy.h", "Sources/Custom/Details/SAMKeychain/SAMKeychain.h", "Sources/Custom/Details/SAMKeychain/SAMKeychainQuery.h", "Sources/Custom/Details/Alert/HUD/MBProgressHUD/MBProgressHUD.h"

        ss.dependency "AppExtension/Core"
        ss.dependency "AppExtension/Codable"
        ss.dependency "AppExtension/Animater"
        
        ss.dependency "SnapKit"
    end

    s.subspec "Third" do |ss|
        ss.source_files  = "Sources/Third/**/*.{swift}"
        ss.resource = "Sources/Third/**/*.{bundle}"

        ss.dependency "AppExtension/Core"
        ss.dependency "AppExtension/Animater"
        ss.dependency "AppExtension/Custom"
        
        ss.dependency "RxSwift"
        ss.dependency "RxCocoa"
        ss.dependency "RxGesture"
        ss.dependency "RxSwiftExt"
        ss.dependency "RxOptional"
        
        ss.dependency "Rx+Kingfisher"
        ss.dependency "Result"
        
    end

    s.subspec "List" do |ss|
        ss.source_files  = "Sources/List/**/*.{swift}"

        ss.dependency "AppExtension/Core"
        ss.dependency "AppExtension/Animater"
        ss.dependency "AppExtension/Custom"
        ss.dependency "AppExtension/Third"
        
        ss.dependency "DifferenceKit"
        ss.dependency "MJRefresh"
    end

    s.subspec "UserNotificationManager" do |ss|
        ss.source_files  = "Sources/UserNotificationManager/**/*.{swift}"

        ss.dependency "AppExtension/Core"

        ss.dependency "RxSwift"
    end

    s.subspec "RouterManager" do |ss|
        ss.source_files  = "Sources/RouterManager/**/*.{swift}"

        ss.dependency "AppExtension/Core"
    end

    s.subspec "AnimatedTransition" do |ss|
        ss.source_files  = "Sources/AnimatedTransition/**/*.{swift}"

        ss.dependency "AppExtension/Custom"
        ss.dependency "AppExtension/Animater"
    end

end
