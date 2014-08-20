require 'ruby_hashcat/api'
require 'ruby_hashcat/parse'
require 'ruby_hashcat/program'
require 'ruby_hashcat/task'
require 'ruby_hashcat/tools'
require 'ruby_hashcat/validation'
require 'ruby_hashcat/version'

module RubyHashcat
  # Hashcat Rest API
  def self.start_api(hashcat_location)
    RubyHashcat::API.set :ocl_location, hashcat_location
    RubyHashcat::API.run!
  end
end

if __FILE__ == $0
  RubyHashcat.start_api('/location/of/oclhashcat/')
end