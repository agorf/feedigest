Gem::Specification.new do |gem|
  gem.name          = 'feedigest'
  gem.version       = '0.0.1'
  gem.author        = 'Angelos Orfanakos'
  gem.email         = 'me@agorf.gr'
  gem.homepage      = 'https://github.com/agorf/feedigest'
  gem.summary       = 'RSS/Atom feed updates as a digest email'
  gem.license       = 'MIT'

  gem.files         = Dir['lib/**/*.rb', 'bin/*', '*.md', 'LICENSE.txt']
  gem.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 2.3.3'

  gem.add_dependency 'feedjira', '~> 2.1'
  gem.add_dependency 'mail', '~> 2.7'
  gem.add_dependency 'nokogiri', '~> 1.8'
  gem.add_dependency 'reverse_markdown', '~> 1.1'

  gem.add_development_dependency 'dotenv', '~> 2.4'
end
