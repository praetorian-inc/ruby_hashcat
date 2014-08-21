require 'sinatra/base'
require 'thin'
require 'sucker_punch'
require 'json'
require 'pp'

###########################################################################
# Author:                                                 Coleton Pierson #
# Company:                                                     Praetorian #
# Date:                                                   August 20, 2014 #
# Project:                                                   Ruby Hashcat #
# Description:          Main API class. Loads routes and sinatra methods. #
###########################################################################

module RubyHashcat

  class API < Sinatra::Application
    path = File.dirname(__FILE__)
    require "#{path}/routes/init"
  end

end