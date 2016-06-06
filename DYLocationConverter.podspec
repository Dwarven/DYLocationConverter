Pod::Spec.new do |s|

  s.name                  = 'DYLocationConverter'
  s.version               = '0.0.1'
  s.summary               = 'A location converter between WGS84 GCJ-02 and BD-09.'
  s.homepage              = 'https://github.com/Dwarven/DYLocationConverter'
  s.ios.deployment_target = '7.0'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Dwarven' => 'prison.yang@gmail.com' }
  s.source                = { :git => 'https://github.com/Dwarven/DYLocationConverter.git', :tag => s.version }
  s.source_files          = 'Class/*.{h,m}'
  s.ios.frameworks        = 'CoreLocation', 'MapKit'
  s.dependency              'DYCoordinateInChina'

end
