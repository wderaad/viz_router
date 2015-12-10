#geo_ip.rb
#wderaad
require 'rubygems'
require 'bundler/setup'
require 'mongo'
require 'json'
require 'rest-client'
require 'mongoid'

Mongoid.load!('mongoid.yml', :production)
module GeoIP
  class Geo
    include Mongoid::Document
    field :address
    field :country
    field :stateprov
    field :city
    store_in collection: 'geo_ip'
  end

  class GeoFromIP

    def getGeo(ip)
      resp = getFromDb(ip)
      if resp.nil? || resp.empty?
        resp = getFromRest(ip)
        Geo.new(resp).save
      end
      resp
    end

    def getFromDb(ip)
      db = Mongoid::Sessions.default
      db[:geo_ip].find("address" => ip).first
    end

    def getFromRest(ip)
      key = '1928f12e53f21ff7e3c74067e4208d64803081c9'
      JSON.parse RestClient.get 'http://api.db-ip.com/addrinfo',
                                {:params =>
                                     {:addr => ip, 'api_key' => key}}
    end


  end
end
