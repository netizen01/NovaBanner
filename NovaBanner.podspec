Pod::Spec.new do |spec|

    spec.name           = 'NovaBanner'
    spec.version        = '0.3'
    spec.summary        = 'Another Banner Package. Because.'

    spec.homepage       = 'https://github.com/netizen01/NovaBanner'
    spec.license        = { :type => 'MIT', :file => 'LICENSE' }
    spec.author         = { 'Netizen01' => 'n01@invco.de' }

    spec.ios.deployment_target  = '8.2'

    spec.source         = { :git => 'https://github.com/netizen01/NovaBanner.git',
                            :tag => spec.version.to_s }
    spec.source_files   = 'Source/**/*.swift'

    spec.dependency     'NovaCore'
    spec.dependency     'Cartography'

end
