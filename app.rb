require 'nokogiri'
require 'pry'
require 'active_record'
require_relative './train_data'

ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])

NJTranist::ScheduleSucker.run
