require 'socket'
require 'timeout'

def is_port_open?(ip, port)
  begin
    Timeout::timeout(1) do
      begin
        s = TCPSocket.new(ip, port)
        s.close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::EADDRNOTAVAIL
        return false
      end
    end
  rescue Timeout::Error
  end

  return false
  end

(0..200).each do |port|
  puts "port #{port}", is_port_open?('54.213.216.70', port)
end