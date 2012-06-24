$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "graph_mapper_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "graph_mapper_rails"
  s.version     = GraphMapperRails::VERSION
  s.authors     = ["parroty"]
  s.email       = ["parroty00@gmail.com"]
  s.homepage    = "http://www.example.com"
  s.summary     = "rails plugin for graph mapper"
  s.description = "rails plugin for graph mapper"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
