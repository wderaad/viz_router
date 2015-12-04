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

$host = ARGV[0]
def ports_open?(port_range)
  ret = []
  port_range.each do |port|
    if is_port_open?($host, port)
      ret << port
    end
  end
  return ret
end

a = (1..100).to_a
b = (200..310).to_a
t1=Thread.new{ports_open?(a)}
t2=Thread.new{ports_open?(b)}
a1 = t1.value
a2 = t2.value
a1.concat a2
puts a1