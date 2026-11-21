# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'datamapper-money/version'

Gem::Specification.new do |gem|
  gem.name          = "datamapper-money"
  gem.version       = Datamapper::Money::VERSION
  gem.authors       = ["Smudge"]
  gem.email         = ["nathan@ngriffith.com"]
  gem.summary       = %q{DataMapper-enabled use of 'money' rubygem.}
  gem.description   = %q{Adds a 'money' instance method to DataMapper-based models, for creating properties powered by the 'money' rubygem.}
  gem.homepage      = "http://github.com/Smudge/datamapper-money"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'sbf-dm-core', '~> 1.3'
  gem.add_dependency 'money', '>= 5', '< 8'
end
