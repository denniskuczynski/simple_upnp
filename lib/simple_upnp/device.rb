require 'net/http'

module SimpleUpnp
  class Device

    attr_reader :st, :server, :usn, :location

    def initialize(message)
      lines = message.split(/\r?\n/)
      lines.each do |line|
        if line =~ /^ST:/i
          @st = parse_token(line.split(': '))
        elsif line =~ /^SERVER:/i
          @server = parse_token(line.split(': '))
        elsif line =~ /^USN:/i
          line = line.sub('USN:', 'USN: ') unless line =~ /^USN: /
          @usn = parse_token(line.split(': '))
          # Trim off data after ::
          # For example, we don't want upnp:rootdevice from uuid:7DD8D98F-6577-582D-AF37-38B92EB830A4::upnp:rootdevice
          @usn = @usn.split('::').first
        elsif line =~ /^LOCATION:/i
          @location = parse_token(line.split(': '))
        end
      end
    end

    def to_json(include_location_details = false)
      h = {
        :st => st,
        :server => server,
        :usn => usn,
        :location => location
      }
      h.merge!(retrieve_location_details) if include_location_details and location
      h
    end

    private

    def parse_token(tokens)
      value = nil
      value = tokens[1] if tokens.length >= 2
      value
    end

    def retrieve_location_details
      url = URI.parse(location)
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
      parser = Nori.new(:parser => :rexml)
      parser.parse(res.body)
    end

  end
end
