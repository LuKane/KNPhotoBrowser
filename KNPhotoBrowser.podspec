Pod::Spec.new do |s|

  s.name         = "KNPhotoBrowser"
  s.version      = "1.0"
  s.summary      = "A lightweight and beautiful photo or video browser and adapt rotate screen"

  s.description  = <<-DESC
                   A lightweight and beautiful photo or video browser and adapt rotate screen
                   DESC
  s.homepage     = "https://github.com/LuKane/KNPhotoBrowser"
  # s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "LuKane" => "1169604556@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LuKane/KNPhotoBrowser.git", :tag =>"1.0" }
  s.source_files  = "KNPhotoBrowser/KNPhotoBrowser/**/*.{h,m}"

  s.requires_arc = true
  s.dependency 'SDWebImage',"~> 5.0.0"

end
