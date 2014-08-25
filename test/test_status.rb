path = File.dirname(__FILE__)
require "#{path}/../lib/ruby_hashcat"
require 'pp'

pp RubyHashcat::Parse.stdout('tmp/stdout.txt')[-1]