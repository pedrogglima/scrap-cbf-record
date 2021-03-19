# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrap_cbf_record/version'

Gem::Specification.new do |spec|
  spec.name          = 'scrap_cbf_record'
  spec.version       = ScrapCbfRecord::VERSION
  spec.authors       = ['Pedro Lima']
  spec.email         = ['pedrogglima@gmail.com']

  spec.summary       = 'ScrapCbfRecord is a module from ScrapCbf gem. It is responsible for saving the data scraped by ScrapCbf.'
  spec.description   = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'activesupport', '~> 5.2.3'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 12.3.2'
  spec.add_development_dependency 'rspec', '~> 3.10.0'
  spec.add_development_dependency 'rubocop', '~> 0.81.0'
  spec.add_development_dependency 'yard', '~> 0.9'
end
