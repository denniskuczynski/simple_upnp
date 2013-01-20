require 'socket'
require 'timeout'

module SimpleUpnp
  class Discovery

    SSDP_ADDR = '239.255.255.250'
    SSDP_PORT = 1900
    M_SEARCH = "M-SEARCH * HTTP/1.1\r\nHOST: #{SSDP_ADDR}:#{SSDP_PORT}\r\nMAN: \"ssdp:discover\"\r\nMX: 2\r\nST: ssdp:all\r\n\r\n"
    MAX_RECEIVE_LENGTH = 65536

    # Signal the uPnP Multicast address and wait for responses, returning an array of SimpleUpnp::Devices
    def self.search(seconds_to_listen=5)
      socket = UDPSocket.new
      socket.bind('', SSDP_PORT)
      socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_TTL, [1].pack('i'))
      socket.send(M_SEARCH, 0, SSDP_ADDR, SSDP_PORT)
      messages = receive_messages(socket, seconds_to_listen)
      socket.close

      devices = process_messages(messages)
    end

    private

    # Read responses from the socket until the Timout triggers
    def self.receive_messages(socket, seconds_to_listen)
      messages = []
      begin
        Timeout::timeout(seconds_to_listen) do
          while true
            message, sender = socket.recvfrom(MAX_RECEIVE_LENGTH)
            messages << message
          end
        end
      rescue Timeout::Error => e
        # Finished Listening
      end
      messages
    end

    # Convert messages to a unique array of Devices
    def self.process_messages(messages)
      devices = []
      messages.each do |message|
        device = SimpleUpnp::Device.new(message)
        index = devices.index { |x| x.usn == device.usn }
        devices << device if index.nil?
      end
      devices
    end

  end
end
