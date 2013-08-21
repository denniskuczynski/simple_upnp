# -*- encoding: utf-8 -*-
require File.expand_path('../lib/simple_upnp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dennis Kuczynski"]
  gem.email         = ["dennis.kuczynski@gmail.com"]
  gem.description   = %q{Simple library to perform basic UPnP network discovery.}
  gem.summary       = %q{Simple library to perform basic UPnP network discovery.}
  gem.homepage      = ""
  gem.license         = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "simple_upnp"
  gem.require_paths = ["lib"]
  gem.version       = SimpleUpnp::VERSION

  gem.add_dependency "nori",  '~> 2.0.0'
  gem.add_development_dependency "rspec", '~> 2.12.0'

end
