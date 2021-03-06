Pod::Spec.new do |s|

    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = "SwiftDialogController"
    s.summary = "UIViewController that can be presented on top of another UIViewController, with behaviors similar to Android's DialogFragment."
    s.requires_arc = true
    s.version = "1.1.3"
    s.license = { :type => "Apache-2.0", :file => "LICENSE" }
    s.author = { "Hai Pham" => "swiften.svc@gmail.com" }
    s.homepage = "https://github.com/protoman92/SwiftDialogController.git"
    s.source = { :git => "https://github.com/protoman92/SwiftDialogController.git", :tag => "#{s.version}"}
    s.framework = "UIKit"
    s.dependency 'SwiftBaseViews/Main'

    s.subspec 'Main' do |main|
        main.source_files = "SwiftDialogController/**/*.{swift}"
    end

end
