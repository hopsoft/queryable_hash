# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'queryable_hash/version'

Gem::Specification.new do |spec|
  spec.name          = "queryable_hash"
  spec.version       = QueryableHash::VERSION
  spec.authors       = ["Nathan Hopkins"]
  spec.email         = ["natehop@gmail.com"]
  spec.summary       = "Makes hashes queryable with a simple dot query."
  spec.description   = "Makes hashes queryable with a simple dot query."
  spec.homepage      = "https://github.com/hopsoft/queryable_hash"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"]
  spec.test_files    = Dir["test/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry-test"
end
