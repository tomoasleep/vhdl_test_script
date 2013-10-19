# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vhdl_test_script/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tomoya Chiba", "tomykaira"]
  gem.email         = ["tomo.asleep@gmail.com", "tomykaira@gmail.com"]
  gem.description   = %q{Run parameterized test for VHDL written in DSL with Ruby.}
  gem.summary       = %q{Run parameterized test for VHDL written in DSL with Ruby.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vhdl_test_script"
  gem.require_paths = ["lib"]
  gem.version       = VhdlTestScript::VERSION

  gem.add_development_dependency 'rspec', '~> 2.11'
  gem.add_development_dependency 'rake'
end
