Pod::Spec.new do |spec|
  spec.name    = 'K9LumberjackPatternLogFormatter'
  spec.version = '0.1.0'
  spec.summary = 'CocoaLumberjack custom formatter configurable with pattern string'
  spec.license = 'MIT'
  spec.author  = { 'Takanori Ishikawa' => 'takanori.ishikawa@gmail.com' }
  spec.source  = { :git => 'http://EXAMPLE/NAME.git', :tag => spec.version.to_s }

  spec.source_files = 'Classes'
  spec.frameworks   = 'Foundation'
  spec.requires_arc = true
  spec.dependency   = 'CocoaLumberjack'
end
