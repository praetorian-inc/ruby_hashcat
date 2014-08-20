path = File.dirname(__FILE__)
require 'ruby_hashcat'
require 'pp'

worker = RubyHashcat::Objects::Hash.new(1, '/home/ubuntu/tools/oclHashcat-1.01/cudaHashcat64.bin')

worker.attack = 0
worker.hash = "#{path}/hashes/md5crypt.txt"
worker.word_list = "#{path}/wordlists/wordlist.dict"
worker.rules = "#{path}/rules/InsidePro-PasswordsPro.rule"
worker.type = 500

worker.crack(true)

10.times do
  worker.status
  sleep 10
end

pp worker.results