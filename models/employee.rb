#wderaad
require 'mongoid'
Mongoid.load!('mongoid.yml', :production)
class Employee
  include Mongoid::Document
  field :full_name, type: String
  field :user_name, type: String
  field :site_country, type: String
  field :site_sp, type: String
  store_in collection: 'employee'
end

emp = Employee.where(user_name: "jsmith").first

if emp
  emp.set(full_name: "James Smith",user_name: "jsmith",site_country: "US" ,site_sp: "California")
else
  emp = Employee.new(full_name: "James Smith", user_name: "jsmith",site_country: "UV" ,site_sp: "California")
end
emp.save