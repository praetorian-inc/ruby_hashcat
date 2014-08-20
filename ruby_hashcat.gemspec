# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_hashcat/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_hashcat'
  spec.version       = RubyHashcat::VERSION
  spec.authors       = ['Coleton Pierson']
  spec.email         = ['coleton.pierson@praetorian.com']
  spec.summary       = %q{Hashcat Library. Includes a rest API, library, and wrapper for oclHashcat.}
  spec.description   = %q{Hashcat library and API written in ruby to interface with oclHashcat.
                          Ability to start and check status of cracking hash files.}
  spec.homepage      = 'http://praetorian.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.1'
  spec.add_development_dependency 'rest-client', '~> 1.7'
  spec.add_runtime_dependency 'sinatra', '~> 1.4'
  spec.add_runtime_dependency 'thin', '~> 1.6'
  spec.add_runtime_dependency 'sucker_punch', '~> 1.1'
  spec.add_runtime_dependency 'rprogram', '~> 0.3'

end