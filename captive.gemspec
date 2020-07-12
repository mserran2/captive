# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'captive/version'

Gem::Specification.new do |spec|
  spec.name          = 'captive'
  spec.version       = Captive::VERSION
  spec.authors       = %w[mserran2]
  spec.email         = ['mark@markserrano.me']

  spec.summary       = 'Ruby Subtitle Manager, Editor and Converter'
  spec.description   = 'Captive allows for parsing managing and converting of subtitles across differetnt formats in addition to JSON'
  spec.homepage      = 'https://github.com/mserran2/captive'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop', '~> 0.87.1'
end
