lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stanley/version'

Gem::Specification.new do |spec|
  spec.name          = 'stanley'
  spec.version       = Stanley::VERSION
  spec.authors       = ['Daniel Vandersluis']
  spec.email         = ['daniel.vandersluis@gmail.com']

  spec.summary       = 'NHL API wrapper and stats package'
  spec.homepage      = 'https://github.com/dvandersluis/stanley'

  spec.metadata['allowed_push_host'] = 'https://www.rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGES.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 1.0.0'
  spec.add_dependency 'zeitwerk'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
end
