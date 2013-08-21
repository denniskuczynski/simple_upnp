[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/denniskuczynski/simple_upnp)

# simple_upnp

A few libraries already exist for working with Universal Plug and Play (UPnP) devices.

This library tries to provide a minimal implementation for discovery with a small amount of code and library dependencies.

For more info on uPnP, see:
http://www.upnp-hacks.org/upnp.html

## Installation

Add this line to your application's Gemfile:

    gem 'simple_upnp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_upnp

## Usage

You may either:
  * search for a configurable number of seconds and return all unique devices that have responded.
  * attempt to find a specific device and exit early once found

The following example shows *search* (which can be triggered with the included rake task: "rake simple_upnp:search"):
```ruby
include_location_details = true
devices = SimpleUpnp::Discovery.search()
devices.each do |device|
  puts 'Device Found: '
  puts device.to_json(include_location_details)
  puts ''
end
```

The following example shows *find* (which can be triggered with the included rake task: "rake simple_upnp:find_hue"):
```ruby
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
```

Search should produce output similar to the following:
```
Searching for devices...
Device Found: 
{:st=>"upnp:rootdevice", :server=>"Darwin 11.4.2 CyberLinkC/2.3 UPnP/1.0 DLNADOC/1.50", :usn=>"uuid:7DD8D98F-6577-582D-AF37-38B92EB830A4", :location=>"http://10.10.10.3:38400/description.xml", "root"=>{"specVersion"=>{"major"=>"1", "minor"=>"0"}, "device"=>{"deviceType"=>"urn:dmc-samsung-com:device:SyncServer:1", "friendlyName"=>"Adam’s MacBook Pro", "manufacturer"=>"Samsung-Electronics", "manufacturerURL"=>"http://www.samsung.com", "modelDescription"=>"Kies Sync Server", "modelName"=>"Kies Sync Server", "modelNumber"=>"1.0", "modelURL"=>"http://www.samsung.com", "UDN"=>"uuid:7DD8D98F-6577-582D-AF37-38B92EB830A4", "serviceList"=>{"service"=>{"serviceType"=>"urn:dmc-samsung-com:service:SyncManager:1", "serviceId"=>"urn:dmc-samsung-com:serviceId:SyncManager", "controlURL"=>"/KiesControll", "eventSubURL"=>"/KiesEventSub", "SCPDURL"=>"/KiesService_SCPD.xml"}}}, "URLBase"=>"http://10.10.10.3:38400", "@xmlns"=>"urn:schemas-upnp-org:device-1-0"}}

Device Found: 
{:st=>"upnp:rootdevice", :server=>"FreeRTOS/6.0.5, UPnP/1.0, IpBridge/0.1", :usn=>"uuid:2f402f80-da50-11e1-9b23-001788092b7e", :location=>"http://10.10.10.104:80/description.xml", "root"=>{"specVersion"=>{"major"=>"1", "minor"=>"0"}, "URLBase"=>"http://10.10.10.104:80/", "device"=>{"deviceType"=>"urn:schemas-upnp-org:device:Basic:1", "friendlyName"=>"Philips hue (10.10.10.104)", "manufacturer"=>"Royal Philips Electronics", "manufacturerURL"=>"http://www.philips.com", "modelDescription"=>"Philips hue Personal Wireless Lighting", "modelName"=>"Philips hue bridge 2012", "modelNumber"=>"929000242503", "modelURL"=>"http://www.meethue.com", "serialNumber"=>"001788542b7e", "UDN"=>"uuid:2f402f80-da50-11e1-9b23-001788092b7e", "serviceList"=>{"service"=>{"serviceType"=>"(null)", "serviceId"=>"(null)", "controlURL"=>"(null)", "eventSubURL"=>"(null)", "SCPDURL"=>"(null)"}}, "presentationURL"=>"index.html", "iconList"=>{"icon"=>[{"mimetype"=>"image/png", "height"=>"48", "width"=>"48", "depth"=>"24", "url"=>"hue_logo_0.png"}, {"mimetype"=>"image/png", "height"=>"120", "width"=>"120", "depth"=>"24", "url"=>"hue_logo_3.png"}]}}, "@xmlns"=>"urn:schemas-upnp-org:device-1-0"}}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

simple_upnp is released under the MIT license:

http://www.opensource.org/licenses/MIT

It makes use of the following libraries:

Nori - https://github.com/savonrb/nori