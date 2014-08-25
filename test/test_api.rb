path = File.dirname(__FILE__)
require 'pp'
require 'rest-client'
require 'json'

def normal
  path = File.dirname(__FILE__)
  attack = 0
  hash = "#{path}/hashes/md5.txt"
  word_list = "#{path}/wordlists/wordlist.dict"
  rules = "best64.rule"
  type = 0

  request = RestClient::Request.new(
      :method => :post,
      :url => '127.0.0.1:4567/crack.json',
      :payload => {
          multipart: true,
          hash: File.new(hash, 'rb'),
          word_list: File.new(word_list, 'rb'),
          id: 1,
          attack: attack,
          rule_sets: rules,
          type: type
      }
  )
  response = request.execute

  pp response

  pp JSON.parse(RestClient.get '127.0.0.1:4567/status.json', {:params => {:id => 1}})

  while JSON.parse(RestClient.get '127.0.0.1:4567/status.json', {:params => {:id => 1}})['status'] == 'running'
    pp JSON.parse(RestClient.get '127.0.0.1:4567/status-advanced.json', {:params => {:id => 1}})
    sleep 10
  end

  pp JSON.parse(RestClient.get '127.0.0.1:4567/results.json', {:params => {:id => 1}})

end

def charset
  path = File.dirname(__FILE__)
  attack = 3
  hash = "#{path}/hashes/md5.txt"
  charset = '?l?l?l?l?l?l?l?l'
  type = 0

  request = RestClient::Request.new(
      :method => :post,
      :url => '127.0.0.1:4567/crack.json',
      :payload => {
          multipart: true,
          hash: File.new(hash, 'rb'),
          charset: charset,
          id: 2,
          attack: attack,
          type: type
      }
  )
  response = request.execute

  pp response

  pp JSON.parse(RestClient.get '127.0.0.1:4567/status.json', {:params => {:id => 2}})

  while JSON.parse(RestClient.get '127.0.0.1:4567/status.json', {:params => {:id => 2}})['status'] == 'running'
    pp JSON.parse(RestClient.get '127.0.0.1:4567/status-advanced.json', {:params => {:id => 2}})
    sleep 30
  end

  pp JSON.parse(RestClient.get '127.0.0.1:4567/results.json', {:params => {:id => 2}})

end

def combination
  path = File.dirname(__FILE__)
  attack = 1
  hash = "#{path}/hashes/md5.txt"
  word_list = "#{path}/wordlists/wordlist.dict"
  word_list_2 = "#{path}/wordlists/wordlist.dict"
  type = 0

  request = RestClient::Request.new(
      :method => :post,
      :url => '127.0.0.1:4567/crack.json',
      :payload => {
          multipart: true,
          hash: File.new(hash, 'rb'),
          word_list: File.new(word_list, 'rb'),
          word_list_2: File.new(word_list_2, 'rb'),
          id: 3,
          attack: attack,
          type: type
      }
  )
  response = request.execute

  pp response

  pp JSON.parse(RestClient.get '127.0.0.1:4567/status.json', {:params => {:id => 3}})

  while JSON.parse(RestClient.get '127.0.0.1:4567/status.json', {:params => {:id => 3}})['status'] == 'running'
    pp JSON.parse(RestClient.get '127.0.0.1:4567/status-advanced.json', {:params => {:id => 3}})
    sleep 30
  end

  pp JSON.parse(RestClient.get '127.0.0.1:4567/results.json', {:params => {:id => 3}})

end

def hybrid_1
  path = File.dirname(__FILE__)
  attack = 6
  hash = "#{path}/hashes/md5.txt"
  word_list = "#{path}/wordlists/wordlist.dict"
  charset = '?d?d?d'
  type = 0

  request = RestClient::Request.new(
      :method => :post,
      :url => '127.0.0.1:4567/crack.json',
      :payload => {
          multipart: true,
          hash: File.new(hash, 'rb'),
          word_list: File.new(word_list, 'rb'),
          charset: charset,
          id: 4,
          attack: attack,
          type: type
      }
  )
  response = request.execute

  pp response

  pp JSON.parse(RestClient.get '127.0.0.1:4567/status.json', {:params => {:id => 4}})

  while JSON.parse(RestClient.get '127.0.0.1:4567/status.json', {:params => {:id => 4}})['status'] == 'running'
    pp JSON.parse(RestClient.get '127.0.0.1:4567/status-advanced.json', {:params => {:id => 4}})
    sleep 10
  end

  pp JSON.parse(RestClient.get '127.0.0.1:4567/results.json', {:params => {:id => 4}})

end

def hybrid_2
  path = File.dirname(__FILE__)
  attack = 7
  hash = "#{path}/hashes/md5.txt"
  word_list = "#{path}/wordlists/wordlist.dict"
  charset = '?d?d?d'
  type = 0

  request = RestClient::Request.new(
      :method => :post,
      :url => '127.0.0.1:4567/crack.json',
      :payload => {
          multipart: true,
          hash: File.new(hash, 'rb'),
          word_list: File.new(word_list, 'rb'),
          charset: charset,
          id: 5,
          attack: attack,
          type: type
      }
  )
  response = request.execute

  pp response

  pp JSON.parse(RestClient.get '127.0.0.1:4567/status.json', {:params => {:id => 5}})

  while JSON.parse(RestClient.get '127.0.0.1:4567/status.json', {:params => {:id => 5}})['status'] == 'running'
    pp JSON.parse(RestClient.get '127.0.0.1:4567/status-advanced.json', {:params => {:id => 5}})
    sleep 10
  end

  pp JSON.parse(RestClient.get '127.0.0.1:4567/results.json', {:params => {:id => 5}})

end

#normal
#charset
combination
#hybrid_1
#hybrid_2