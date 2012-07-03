source "http://rubygems.org"

# Declare your gem's dependencies in graph_mapper_rails.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

gem 'rails', '3.2.6'
gem "lazy_high_charts", "~> 1.1.5"
gem "graph_mapper", :git => 'git@github.com:parroty/graph_mapper.git', :branch => 'master'

# group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "twitter-bootstrap-rails", "~> 2.1.0"
# end

gem 'simple_form'

group :development, :test do
  gem "rspec", "~> 2.8.0"
  gem "rspec-rails", "~> 2.8.1"
  gem 'factory_girl_rails'
end