# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "edits/version"

Gem::Specification.new do |spec|
  spec.name          = "edits"
  spec.version       = Edits::VERSION
  spec.authors       = ["Tom Crouch"]
  spec.email         = ["tom.crouch@gmail.com"]

  spec.summary       = "A collection of edit distance algorithms."
  # spec.description   = "TODO: Write a longer description or delete this line."
  spec.homepage      = "https://github.com/tcrouch/edits"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "redcarpet"
  spec.add_development_dependency "yard", "~> 0.9.9"
end
