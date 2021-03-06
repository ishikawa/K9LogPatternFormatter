Pod::Spec.new do |spec|
  spec.name     = 'K9LogPatternFormatter'
  spec.version  = '2.0.0'
  spec.summary  = 'K9LogPatternFormatter is flexible logging message formatter configurable with pattern string'
  spec.homepage = 'https://github.com/ishikawa/K9LogPatternFormatter'
  spec.license  = 'MIT'
  spec.author   = { 'Takanori Ishikawa' => 'takanori.ishikawa@gmail.com' }
  spec.source   = {
    :git => 'https://github.com/ishikawa/K9LogPatternFormatter.git',
    :tag => spec.version.to_s,
  }

  spec.frameworks   = 'Foundation'
  spec.requires_arc = true

  spec.ios.deployment_target = '7.0'
  spec.osx.deployment_target = '10.9'

  spec.subspec 'Core' do |core|
    core.source_files = 'Classes/Core/**/*.{h,m}'
  end

  spec.subspec 'Lumberjack' do |lumberjack|
    lumberjack.source_files = 'Classes/Lumberjack/**/*.{h,m}'
    lumberjack.dependency 'K9LogPatternFormatter/Core'
    lumberjack.dependency 'CocoaLumberjack/Default'
  end

end
