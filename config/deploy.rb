require 'capistrano/ext/multistage'     # Support for multiple deploy targets
require 'capistrano-helpers/branch'     # Ask user what tag to deploy
require 'capistrano-helpers/passenger'  # Support for Apache passenger
require 'capistrano-helpers/git'        # Support for git
require 'capistrano-helpers/shared'     # Symlink shared files after deploying
require 'capistrano-helpers/gems'       # Install all required rubygems
require 'capistrano-helpers/migrations' # Run all migrations automatically
require 'capistrano-helpers/campfire'   # Post deploy info to campfire

# The name of the application.
set :application, "PROJECT"

# Location of the source code.
set :repository,  "git@github.com:westarete/PROJECT.git"

# Set the files that should be replaced with their private counterparts.
set :shared, %w{ 
  config/database.yml 
  config/initializers/session_store.rb
}
