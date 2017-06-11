# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acmaker/version'

Gem::Specification.new do |spec|
  spec.name          = 'acmaker'
  spec.version       = Acmaker::VERSION
  spec.authors       = ['Yuta Horii']
  spec.email         = ['horiyutwins@gmail.com']

  spec.summary       = 'Acmaker is a tool to manage AWS Certificate Manager (ACM).'
  spec.description   = 'Acmaker is a tool to manage AWS Certificate Manager (ACM). It defines the state of ACM using DSL, and updates ACM according to DSL.'
  spec.homepage      = 'https://github.com/yutadayo/acmaker'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'aws-sdk', '~>2'
  spec.add_dependency 'diffy'
  spec.add_dependency 'parallel'
  spec.add_dependency 'term-ansicolor'
end
