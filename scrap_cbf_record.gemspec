# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrap_cbf_record/version'

Gem::Specification.new do |gem|
  gem.name          = 'scrap_cbf_record'
  gem.version       = ScrapCbfRecord::VERSION
  gem.authors       = ['Pedro Lima']
  gem.email         = ['pedrogglima@gmail.com']

  gem.summary       = 'ScrapCbfRecord is a module from ScrapCbf gem.' \
  ' It is responsible for saving the data scraped by ScrapCbf.'
  gem.description   = ''
  gem.homepage      = ''
  gem.license       = 'MIT'

  gem.files         = Dir['lib/**/*.rb']
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '~> 5.2.3'
  gem.add_dependency 'json', '~> 2.5'

  # gem.add_development_dependencies load on spec/setup/Gemfile
  # Note: gems for test that are meant to be running inside docker
  #  must be added on spec/setup/Gemfile.
  # Note: gems on spec/setup/Gemfile are installed through Dockerfile cmd.
  # Note: gems added here must be installed locally through cmd bundle install
  gem.add_development_dependency 'rubocop', '~> 0.81.0'
  gem.add_development_dependency 'yard', '~> 0.9'
end
