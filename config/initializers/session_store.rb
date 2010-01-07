# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails-template_session',
  :secret      => 'db4ec1c450024d4a71e0e3f03b9e83dbda620576b49ba9a01d75fe1ec57254647aca038855e36e607b8855bc2ceae88f93d6499f7cef331e782b441234b88153'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
