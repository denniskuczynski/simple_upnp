require "bundler/gem_tasks"

$LOAD_PATH.unshift File.expand_path("#{File.dirname(__FILE__)}/lib")
require 'simple_upnp'

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default  => :spec

namespace :simple_upnp do
  task :search do
    puts "Searching for devices...\n"
    include_location_details = true
    devices = SimpleUpnp::Discovery.search()
    devices.each do |device|
      puts 'Device Found: '
      puts device.to_json(include_location_details)
      puts ''
    end
  end

  task :find_hue do
    puts "Searching for Phillips Hue...\n"
    include_location_details = true
    hue_device = nil
    SimpleUpnp::Discovery.find do |device|
      device_json = device.to_json(include_location_details)
      if device_json['root']
        if device_json['root']['device']
          if device_json['root']['device']['friendlyName']
            friendlyName = device_json['root']['device']['friendlyName']
            if friendlyName =~ /Philips hue/
              hue_device = device 
              break
            end
          end
        end
      end
    end
    if hue_device
      puts 'Device Found: '
      puts hue_device.to_json(include_location_details)
      puts ''
    end
  end
end