#wderaad
require 'mongoid'
Mongoid.load!('mongoid.yml', :production)
class Employee
  include Mongoid::Document
  field :first_name, type: String
  field :last_name, type: String
  field :user_name, type: String
  field :site_country, type: String
  field :site_sp, type: String
  store_in collection: 'employee'
end

emp = Employee.where(user_name: "jsmith").first

if emp
  emp.set(first_name: "James", last_name: "Smith",user_name: "jsmith",site_country: "US" ,site_sp: "California")
else
  emp = Employee.new(first_name: "James", last_name: "Smith",user_name: "jsmith",site_country: "UV" ,site_sp: "California")
end
emp.save