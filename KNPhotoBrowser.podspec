Pod::Spec.new do |s|

  s.name         = "KNPhotoBrowser"
  s.version      = "2.3"
  s.summary      = "A lightweight and beautiful photo or video browser and adapt rotate screen"
  
  s.description  = <<-DESC
                   A lightweight and beautiful photo or video browser and adapt rotate screen
                   DESC
  s.homepage     = "https://github.com/LuKane/KNPhotoBrowser"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "LuKane" => "1169604556@qq.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/LuKane/KNPhotoBrowser.git", :tag => s.version}
  s.source_files = "KNPhotoBrowser/KNPhotoBrowser/**/*.{h,m}"
  s.resource     = "KNPhotoBrowser/KNPhotoBrowser/KNPhotoBrowser.bundle"
  s.frameworks   = "Foundation","UIKit"
  s.requires_arc = true
  s.dependency "SDWebImage"

end
