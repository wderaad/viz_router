#wderaad
require 'mongoid'
Mongoid.load!('mongoid.yml', :production)
class Summary
  include Mongoid::Document
  field :full_name, type: String
  field :user_name, type: String
  field :site_country, type: String
  field :site_sp, type: String
  field :location_country, type: String
  field :location_sp, type: String
  field :port_access, type: String
  field :login_time, type: Time
  field :time_active, type: Time
  store_in collection: 'summary'
end
