#viz_engine.rb
#wderaad
require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'json'
require 'rest-client'

include Mongo

class GeoIP

  def initialize()
    config_file = File.read('package.json')
    configs = JSON.parse config_file
    #Location of Mongo DB
    mongo_url = configs['config']['db_url']
    mongo_client = Mongo::Connection.from_uri(mongo_url)
    @db = mongo_client.db(File.basename(mongo_url))
    @coll = @db.collection('ip_geo')

  end

  def getGeo(ip)
    resp = getFromDb(ip)
    if resp.nil? || resp.empty?
      resp = getFromRest(ip)
      @coll.insert(resp)
    end
    resp
  end

  def getFromDb(ip)
    @coll.find("address" => ip).to_a
  end

  def getFromRest(ip)
    key = '1928f12e53f21ff7e3c74067e4208d64803081c9'
    JSON.parse RestClient.get 'http://api.db-ip.com/addrinfo',
                          {:params =>
                               {:addr => ip, 'api_key' => key}}
  end


end

g = GeoIP.new
location = g.getGeo('76.120.64.173')
print location