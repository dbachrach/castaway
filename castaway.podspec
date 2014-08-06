Pod::Spec.new do |s|
  s.name             = "castaway"
  s.version          = "0.7.1"
  s.summary          = "Cast objects safely in obj-c"
  s.homepage         = "https://github.com/dbachrach/castaway"
  s.license          = 'MIT'
  s.author           = { "Dustin Bachrach" => "ahdustin@gmail.com" }
  s.source           = { :git => "https://github.com/dbachrach/castaway.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dbachrach'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
end
