path = File.dirname(__FILE__)
require 'ruby_hashcat'

worker = RubyHashcat::Program.new('/opt/cudaHashcat/cudaHashcat64.bin')

File.delete("#{path}/cudaHashcat.log") if File.exists?("#{path}/cudaHashcat.log")
File.delete("#{path}/cudaHashcat.pot") if File.exists?("#{path}/cudaHashcat.pot")
File.delete("#{path}/md5.crack") if File.exists?("#{path}/md5.crack")
File.delete("#{path}/phpass.crack") if File.exists?("#{path}/phpass.crack")
File.delete("#{path}/md5crypt.crack") if File.exists?("#{path}/md5crypt.crack")

# cudaExample0.sh
worker.crack do |crack|
  crack.outfile = "#{path}/md5.crack"
  crack.quiet = true
  crack.disable_restore = true
  crack.disable_potfile = true
  crack.runtime = 15
  crack.markov_threshold = 32
  crack.attack_mode = 7
  crack.hash = "#{path}/hashes/md5.txt"
  crack.charset = '?a?a?a?a'
  crack.wordlist = "#{path}/wordlists/wordlist.dict"
end

# cudaExample400.sh
worker.crack do |crack|
  crack.quiet = true
  crack.disable_restore = true
  crack.disable_potfile = true
  crack.runtime = 15
  crack.hash_type = 400
  crack.outfile = "#{path}/phpass.crack"
  crack.hash = "#{path}/hashes/phpass.txt"
  crack.wordlist = "#{path}/wordlists/wordlist.dict"
end

# cudaExample500.sh
worker.crack do |crack|
  crack.quiet = true
  crack.disable_restore = true
  crack.disable_potfile = true
  crack.hash_type = 500
  crack.runtime = 30
  crack.outfile = "#{path}/md5crypt.crack"
  crack.hash = "#{path}/hashes/md5crypt.txt"
  crack.wordlist = "#{path}/wordlists/wordlist.dict"
end

# Custom Cracking
worker.crack do |crack|
  crack.quiet = true
  crack.disable_restore = true
  crack.disable_potfile = true
  crack.runtime = 120
  crack.rules = ["#{path}/rules/best64.rule", "#{path}/rules/InsidePro-PasswordsPro.rule"]
  crack.hash_type = 0
  crack.outfile = "#{path}/md5_2.crack"
  crack.hash = "#{path}/hashes/md5.txt"
  crack.wordlist = "#{path}/wordlists/wordlist.dict"
end