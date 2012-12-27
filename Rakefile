require "bundler/gem_tasks"

$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/lib")
require 'simple_upnp'

namespace :simple_upnp do
  task :discover do
    puts "Searching for devices...\n"
    include_location_details = true
    devices = SimpleUpnp::Discovery.search()
    devices.each do |device|
      puts 'Device Found: '
      puts device.to_json(include_location_details)
      puts ''
    end
  end
end