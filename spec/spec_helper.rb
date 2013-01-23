require 'rubygems'
require 'bundler/setup'

require 'simple_upnp'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__)+"/support/**/*.rb"].each  do |f|
  require f
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end