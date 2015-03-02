lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/brkt/version'

Gem::Specification.new do |spec|
  spec.name          = "fog-brkt"
  spec.version       = Fog::Brkt::VERSION
  spec.authors       = ["Maksim Zhylinski"]
  spec.email         = [""]
  spec.summary       = %q{Module for the 'fog' gem to support Bracket Computing.}
  spec.description   = %q{This library can be used as a module for `fog` or as standalone provider
                        to use the Bracket Computing services in applications..}
  # spec.homepage      = ""
  # spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.2'

  spec.add_dependency 'fog-core', '~> 1.29'
end
