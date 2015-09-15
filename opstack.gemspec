# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  require 'opstack/version'
  spec.name          = 'opstack'
  spec.version       = OpStack::VERSION
  spec.authors       = ['Salvatore Poliandro']
  spec.email         = %q{oss@opsitters.com}
  spec.description   = %q{A Gem to manage your chef workstation stacks}
  spec.summary       = %q{opstack!}
  spec.homepage      = %q{http://rubygems.org/gems/opstack}
  spec.licenses       = ['MIT', 'GPL-2']

  spec.add_runtime_dependency 'ansi'
  spec.add_runtime_dependency 'thor'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'chef'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'guard', '~> 2.8'
  spec.add_development_dependency 'guard-rspec', '~> 4.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rubocop', '~> 0.27'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-console'

  spec.files         = `git ls-files | grep -v 'demo/'`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
