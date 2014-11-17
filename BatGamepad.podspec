Pod::Spec.new do |s|
s.name = "BatGamepad"
s.version = "1.0.0"
s.summary = "A gamepad controller"
s.homepage = "https://github.com/BaptisteSansierra/BatGamepad"
s.license = "MIT"
s.author = { "Baptiste Sansierra" => "support@batsansierra.com" }
s.source = { :git => "https://github.com/BaptisteSansierra/BatGamepad.git", :tag => "v#{s.version}" }
s.source_files = "BatGamepad/*.{h,m}"
s.framework = "CoreGraphics", "UIKit"
s.requires_arc = true
end