#
# Be sure to run `pod lib lint KKRichTextEditor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
    
    spec.name         = "KKPopTooltip"
    spec.version      = "0.0.2"
    spec.summary      = "弹出气泡"
    
    spec.description  = "一个漂亮的圆角气泡，用来新手引导、操作提示"
    
    spec.homepage     = "https://github.com/liuxiaoxinxin/KKPopTooltip"
    spec.license          = { :type => 'MIT', :file => 'LICENSE' }
    spec.author             = { "liujixin" => "liujixin054@tops001.com" }
    spec.source       = { :git => "https://github.com/liuxiaoxinxin/KKPopTooltip.git", :tag => "#{spec.version}" }
    spec.ios.deployment_target = '9.0'
    
    spec.source_files  = "Source/**"
    spec.resources = "Source/Assets/*"
    
end
