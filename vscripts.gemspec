# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vscripts/version'

Gem::Specification.new do |spec|
  spec.name        = 'vscripts'
  spec.version     = VScripts::VERSION::STRING
  spec.authors     = ['Vlad Ghinea']
  spec.email       = ['vlad@ghn.me']
  spec.summary     = %q{VladGh.com's automation scripts}
  spec.homepage    = 'https://github.com/vghn/vscripts'
  spec.license     = 'Apache 2.0'
  spec.description = <<-EOF
VScripts is a command line utility that performs a series of tasks used on
VladGh.com's deployment.
EOF

  spec.metadata = {
    'issue_tracker' => 'https://github.com/vghn/vscripts/issues'
  }

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_runtime_dependency 'aws-sdk', '~> 1.0'
  spec.add_runtime_dependency 'trollop', '~> 2.0'

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'yard', '~> 0.0'
  spec.add_development_dependency 'reek', '~> 1.0'
  spec.add_development_dependency 'rubocop', '~> 0.0'
  spec.add_development_dependency 'coveralls', '~> 0.0'
  spec.add_development_dependency 'fpm', '~> 1.0'
  spec.add_development_dependency 'travis', '~> 1.0'
end
