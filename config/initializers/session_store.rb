# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_northsignal2_session',
  :secret      => '3a3f75fb77ec05c5c91e61017e1dce456566619df5770d10bdb257b496e055f362e2a809d349dac06887ef00128d62f051a3e9add389f9bf03d165085964c41a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
