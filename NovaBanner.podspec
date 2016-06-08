Pod::Spec.new do |spec|
    spec.name           = 'NovaBanner'
    spec.version        = '0.1'
    spec.license        = { :type => 'MIT' }
    spec.homepage       = 'https://github.com/netizen01/NovaBanner'
    spec.authors        = { 'Netizen01' => 'n01@invco.de' }
    spec.summary        = 'Another Banner Package. Because.'
    spec.source         = { :git => 'https://github.com/netizen01/NovaBanner.git',
                            :tag => spec.version.to_s }
    spec.source_files   = 'Source/**/*.swift'
    spec.dependency     'NovaCore', '~> 0.1'
    spec.dependency     'Cartography', '~> 0.6'

    spec.ios.deployment_target  = '8.4'
end
