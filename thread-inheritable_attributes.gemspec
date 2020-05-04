# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thread/inheritable_attributes/version'

Gem::Specification.new do |spec|
  spec.name          = "thread-inheritable_attributes"
  spec.version       = Thread::InheritableAttributes::VERSION
  spec.authors       = ["Dustin Zeisler"]
  spec.email         = ["dustin@zeisler.net"]

  spec.summary       = %q{Passes thread variables to child spawned threads.}
  spec.description   = %q{Passes thread variables to child spawned threads. Main use case is enabling logging in child thread to keep context of a request.}
  spec.homepage      = "https://github.com/zeisler/thread-inheritable_attributes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_runtime_dependency "request_store", "~> 1.3"
end
