#wderaad
require 'socket'
require 'timeout'

module PortScan
  class PortScan
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

    def ports_open?(ip, port_range)
      ret = []
      port_range.each do |port|
        if is_port_open?(ip, port)
          ret << port
        end
      end
      return ret
    end

    def doScan(ip)
      threads = []
      inc = (1024/100.0).ceil
      100.times do |n|
        s = n*inc + 1
        f = ((n+1)*inc)
        threads[n] = Thread.new{ports_open?(ip,(s..f).to_a)}
      end
      open = []
      threads.each do |t|
        open.push(t.value)
      end
      open.flatten
    end

    def portThreat(ip)
      open = doScan(ip)
      if open.nil? || open.empty?
        return 'Low'
      elsif httpPorts(open)
        return 'Moderate'
      else
        return 'High'
      end
    end

    def httpPorts(open)
      case open.count
        when 1
          return open.include?(80) || open.include?(443)
        when 2
          return open.include?(80) & open.include?(443)
        else
          return false
      end
    end

  end
end