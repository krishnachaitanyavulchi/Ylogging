Pod::Spec.new do |spec|
  spec.name         = 'YLogging'
  spec.version      = ‘1.0.0’
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/krishnachaitanyavulchi/Ylogging/tree/master/Ylogging/ServiceClass'
  spec.authors      = { 'Chaitanya' }
  spec.summary      = ‘Sample Pod’
  spec.source       = { :git => “https://github.com/krishnachaitanyavulchi/Ylogging.git”, :tag => "1.0.0" }
  spec.source_files = 'NLServiceRequestClass.{h,m}'
  spec.framework    = 'SystemConfiguration'
end
