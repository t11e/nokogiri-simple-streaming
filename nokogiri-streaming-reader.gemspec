# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'nokogiri/streaming/version'

Gem::Specification.new do |spec|
  spec.name          = "nokogiri-streaming-reader"
  spec.version       = Nokogiri::Streaming::VERSION
  spec.authors       = ["Alexander Staubo"]
  spec.email         = ["alex@bengler.no"]
  spec.summary       =
  spec.description   = %q{Simple streaming reader for Nokogiri.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", ">= 1.4"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '>= 3.0'
end
