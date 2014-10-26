# RubyHashcat

Ruby wrapper created to run oclHashcat cracking jobs from inside of ruby. Initially created to integrate with a Rest API.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby_hashcat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_hashcat

## Usage

Interact with ruby_hashcat library:

    RubyHashcat::Objects::Hash.new(1, '/path/to/hashcat/executable')

Or start the API:

    RubyHashcat.start_api('/path/to/hashcat/executable', debug)

Or check out the test folder to see some of the examples.

## Contributing

1. Fork it ( https://github.com/coleton/ruby_hashcat/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
