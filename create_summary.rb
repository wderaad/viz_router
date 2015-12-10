#wderaad
require 'mongoid'
require_relative 'lib/geo_ip'
require_relative 'lib/port_scan'
require_relative 'models/summary'
Mongoid.load!('mongoid.yml', :production)

class CreateSummary
  @@geo = GeoIP::GeoFromIP.new
  @@port = PortScan::PortScan.new

  def setEmployeeInfo(user_name)
    db = Mongoid::Sessions.default
    summary = Summary.where(user_name: user_name).first
    if not summary
      summary = Summary.new(user_name: user_name)
    end
    employee = db[:employee].find('user_name' => user_name).first
    summary.full_name = employee[:full_name]
    summary.user_name = user_name
    summary.site_country = employee[:site_country]
    summary.site_sp = employee[:site_sp]
    summary.save
  end

  def setLocationInfo(ip, user_name)
    db = Mongoid::Sessions.default
    summary = Summary.where(user_name: user_name).first
    if not summary
      summary = Summary.new(user_name: user_name)
    end
    location = @@geo.getGeo(ip)
    summary.location_country = location[:country]
    summary.location_sp = location[:stateprov]
    summary.save
  end

  def setPortInfo(ip, user_name)
    summary = Summary.where(user_name: user_name).first
    if not summary
      summary = Summary.new(user_name: user_name)
    end
      summary.port_access = @@port.portThreat(ip)
      summary.save
  end

  def setTimeInfo(user_name)
    db = Mongoid::Sessions.default
    summary = Summary.where(user_name: user_name).first
    if not summary
      summary = Summary.new(user_name: user_name)
    end
    summary.login_time = Time.now
    summary.time_active = Time.now - summary.login_time
    summary.save
  end

  def updateTimeInfo(user_name)
    db = Mongoid::Sessions.default
    summary = Summary.where(user_name: user_name).first
    if not summary
      summary = Summary.new(user_name: user_name)
    end
    summary.time_active = Time.now - summary.login_time
    summary.save
  end

end

sbuilder = CreateSummary.new

sbuilder.setEmployeeInfo('jsmith')
sbuilder.setLocationInfo('54.213.216.70','jsmith')
sbuilder.setPortInfo('54.213.216.70','jsmith')
sbuilder.setTimeInfo('jsmith')