# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_hashcat/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_hashcat'
  spec.version       = RubyHashcat::VERSION
  spec.authors       = ['Rfizzle']
  spec.email         = ['rfizzle@protonmail.ch']
  spec.summary       = %q{Simple command line wrapper for oclHashcat.}
  spec.description   = %q{Command line wrapper created to launch hash cracking jobs with oclHashcat.}
  spec.homepage      = 'http://rfizzle.ch'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.1'
  spec.add_runtime_dependency 'rprogram', '~> 0.3'

end
