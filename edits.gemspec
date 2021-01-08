# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "edits/version"

Gem::Specification.new do |spec|
  spec.name          = "edits"
  spec.version       = Edits::VERSION
  spec.authors       = ["Tom Crouch"]
  spec.email         = ["tom.crouch@gmail.com"]

  spec.summary       = "A collection of edit distance algorithms."
  spec.description   = <<-DESCRIPTION
    Edit distance algorithms including Levenshtein,
    Restricted Edit (Optimal Alignment) and Damerau-Levenshtein distances,
    and Jaro & Jaro-Winkler similarity.
  DESCRIPTION
  spec.homepage      = "https://github.com/tcrouch/edits"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "benchmark-ips", "~> 2.8"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "redcarpet", "~> 3.5"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "simplecov-lcov", "~> 0.8"
  spec.add_development_dependency "yard", "~> 0.9"
end
