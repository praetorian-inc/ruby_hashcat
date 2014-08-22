require 'ruby_hashcat/objects/init'
require 'ruby_hashcat/api'
require 'ruby_hashcat/parse'
require 'ruby_hashcat/program'
require 'ruby_hashcat/task'
require 'ruby_hashcat/tools'
require 'ruby_hashcat/validation'
require 'ruby_hashcat/version'

module RubyHashcat
  # Hashcat Rest API
  def self.start_api(hashcat_location, debug=false)
    RubyHashcat::API.set :ocl_location, hashcat_location
    RubyHashcat::API.set :debug, debug
    RubyHashcat::API.run!
  end
end

if __FILE__ == $0
  path = File.dirname(__FILE__)
  puts File.exists?("#{path}/../../cudaHashcat-1.30/cudaHashcat64.bin")
  RubyHashcat.start_api("#{path}/../../cudaHashcat-1.30/cudaHashcat64.bin", true)
end