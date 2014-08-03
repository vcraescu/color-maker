# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'color/maker/version'

Gem::Specification.new do |spec|
  spec.name          = "color-maker"
  spec.version       = Color::Maker::VERSION
  spec.authors       = ["Viorel Craescu"]
  spec.email         = ["viorel@craescu.com"]
  spec.summary       = %q{Color generator}
  spec.description   = %q{Color generator}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "color", "~> 1.7"
  spec.add_dependency "activesupport"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
