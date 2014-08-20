require 'sinatra/base'
require 'thin'
require 'sucker_punch'
require 'json'
require 'pp'

module RubyHashcat

  class API < Sinatra::Application
    path = File.dirname(__FILE__)
    require "#{path}/routes/init"
  end

end