#viz_engine.rb
#wderaad
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'mongo'
require 'json'
require 'mongoid'
require_relative 'models/summary'
require 'mongoid'

Mongoid.load!('mongoid.yml', :production)


configure do
  #Location of static pages
  config_file = File.read('package.json')
  configs = JSON.parse config_file
  set :port, configs['config']['port']
  #Location of Mongo DB
  #disable :raise_errors, :show_exceptions,:dump_errors,:logging
  #Static files are served before route matching
  enable :static
end

before do
  content_type 'application/json'
end

#Default Page
get '/' do
  content_type 'html'
  erb :index
end

#Summary content from Database
get '/summary' do
  db = Mongoid::Sessions.default
  docs = db[:summary].find.to_a
  ret = Hash[*docs]
  ret.delete('_id')
  ret.to_json
end


error do
  'Following error occured: ' + env['sinatra.error'].message
end

not_found do
  'No route for request: ' + request.path
end
