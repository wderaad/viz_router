require 'json'
require_relative 'create_summary'

class LogPoller
  @@sbuilder = CreateSummary::CreateSummary.new
  def poll
    value = JSON.parse `sudo /usr/local/openvpn_as/scripts/logdba --json`
    v = value.to_a
    uname = v.last[1]
    ip = v.last[7]

    while true do
      value = JSON.parse `sudo /usr/local/openvpn_as/scripts/logdba --json`
      v = value.to_a
      new_uname = v.last[1]
      new_ip = v.last[7]


      if(uname != new_uname || ip != new_ip)
        @@sbuilder.setEmployeeInfo(new_uname)
        @@sbuilder.setLocationInfo(new_ip, new_uname)
        @@sbuilder.setPortInfo(new_ip, new_uname)
        @@sbuilder.setTimeInfo(new_uname)
        uname = new_uname
        ip = new_ip
        puts uname
        puts ip
      end
      sleep(30)
    end
  end
end

g = LogPoller.new
g.poll()S