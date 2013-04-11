# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'find_communities/version'

Gem::Specification.new do |gem|
  gem.name          = "find_communities"
  gem.version       = FindCommunities::VERSION
  gem.authors       = ["Gabe Kopley"]
  gem.email         = ["gabe@coshx.com"]
  gem.description   = %q{Ruby implementation of Louvain community detection method}
  gem.summary       = %q{Ruby implementation of Louvain community detection method}
  gem.homepage      = "https://github.com/gkop/find_communities-ruby"
  gem.license       = "GPL"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "bindata"
  gem.add_dependency "thor"
end
