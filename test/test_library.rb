path = File.dirname(__FILE__)
require 'ruby_hashcat'
require 'pp'

def normal
  path = File.dirname(__FILE__)
  worker = RubyHashcat::Objects::Hash.new(1, '/home/ubuntu/tools/oclHashcat-1.01/cudaHashcat64.bin')
  worker.attack = 0
  worker.hash = "#{path}/hashes/phpass.txt"
  worker.word_list = "#{path}/wordlists/wordlist.dict"
  worker.rules = "passwordspro.rule"
  worker.type = 400
  worker.username = true

  worker.crack(true)

  while worker.running? do
    sleep 15
  end
end

def charset
  path = File.dirname(__FILE__)
  worker = RubyHashcat::Objects::Hash.new(2, '/home/ubuntu/tools/oclHashcat-1.01/cudaHashcat64.bin')
  worker.attack = 3
  worker.hash = "#{path}/hashes/md5.txt"
  worker.charset = '?l?l?l?l?l?l?l?l'
  worker.type = 0
  worker.username = true

  worker.crack(true)

  while worker.running? do
    sleep 15
  end
end

def combination
  path = File.dirname(__FILE__)
  worker = RubyHashcat::Objects::Hash.new(3, '/home/ubuntu/tools/oclHashcat-1.01/cudaHashcat64.bin')
  worker.attack = 1
  worker.hash = "#{path}/hashes/phpass.txt"
  worker.word_list = ["#{path}/wordlists/wordlist.dict", "#{path}/wordlists/wordlist.dict"]
  worker.type = 400
  worker.username = true

  worker.crack(true)

  while worker.running? do
    sleep 15
  end
end

def hybrid_1
  path = File.dirname(__FILE__)
  worker = RubyHashcat::Objects::Hash.new(4, '/home/ubuntu/tools/oclHashcat-1.01/cudaHashcat64.bin')
  worker.attack = 6
  worker.hash = "#{path}/hashes/md5.txt"
  worker.word_list = "#{path}/wordlists/wordlist.dict"
  worker.charset = '?d?d?d'
  worker.type = 0

  worker.crack(true)

  while worker.running? do
    sleep 15
  end
end

def hybrid_2
  path = File.dirname(__FILE__)
  worker = RubyHashcat::Objects::Hash.new(5, '/home/ubuntu/tools/oclHashcat-1.01/cudaHashcat64.bin')
  worker.attack = 7
  worker.hash = "#{path}/hashes/md5.txt"
  worker.charset = '?d?d?d'
  worker.word_list = "#{path}/wordlists/wordlist.dict"
  worker.type = 0

  worker.crack(true)

  while worker.running? do
    sleep 15
  end
end

#normal
#charset
#combination
#hybrid_1
#hybrid_2