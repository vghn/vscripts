# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vscripts/version'

Gem::Specification.new do |spec|
  spec.name          = 'vscripts'
  spec.version       = VScripts::VERSION
  spec.authors       = ['Vlad Ghinea']
  spec.email         = ['vlad@ghn.me']
  spec.description   = %q{VladGh.com's automation scripts}
  spec.summary       = %q{VladGh.com's automation scripts}
  spec.homepage      = 'https://github.com/vghn/vscripts'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk'
  spec.add_runtime_dependency 'unicorn'
  spec.add_runtime_dependency 'sinatra'
  spec.add_runtime_dependency 'trollop'
  spec.add_runtime_dependency 'rake'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rack'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fpm'
end
