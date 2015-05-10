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
      devices = []
      open_socket do |socket|
        process_messages(socket, seconds_to_listen) do |message|
          device = SimpleUpnp::Device.new(message)
          index = devices.index { |x| x.usn == device.usn }
          devices << device if index.nil?
        end
      end
      devices
    end

    # Signal the uPnP Multicast address and wait for responses, which can be processed by an input block accepting a SimpleUpnp::Device
    # Use break to exit the block once you have found the device being looked for
    def self.find(seconds_to_listen=5, &block)
      open_socket do |socket|
        process_messages(socket, seconds_to_listen) do |message|
          device = SimpleUpnp::Device.new(message)
          yield device
        end
      end
    end

    private

    def self.open_socket(&block)
      begin
        socket = UDPSocket.new
        socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, [1].pack('i'))
        socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_TTL, [1].pack('i'))
        socket.bind('', SSDP_PORT)
        socket.send(M_SEARCH, 0, SSDP_ADDR, SSDP_PORT)
        yield socket
      ensure
        socket.close
      end
    end

    def self.process_messages(socket, seconds_to_listen, &block)
      begin
        Timeout::timeout(seconds_to_listen) do
          while true
            message, _ = socket.recvfrom(MAX_RECEIVE_LENGTH)
            yield message
          end
        end
      rescue Timeout::Error
        # Finished Listening
      end
    end

  end
end
