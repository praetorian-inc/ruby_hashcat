require 'sucker_punch'
module RubyHashcat
  module Objects
    class Hash

      def initialize(id, path)
        raise RubyHashcat::Objects::Hash::InvalidHashId unless id.is_a? Integer
        raise RubyHashcat::Objects::Hash::InvalidHashCatLocation unless Dir.exists?(File.dirname(path))
        @id = id
        @path = File.dirname(path)
        @ocl = path
      end

      def crack(async=false)
        # Check if async
        if async
          RubyHashcat::Objects::Hash::Async.new.async.crack(self)
        else
          path = File.dirname(__FILE__)

          # Redirect standard output and errors
          $stdout.reopen("#{path}/../tmp/#{@id}_output.txt", 'w')
          $stderr.reopen("#{path}/../tmp/#{@id}_errors.txt", 'w')

          # Create PID file for this hash ID
          File.touch("#{path}/../tmp/.hashcat_#{@id}_pid")

          worker = RubyHashcat::Program.new(@ocl)

          # Validate Input
          worker.crack do |crack|

            # Hash Type
            crack.hash_type = @type
            # Output
            crack.outfile = "#{path}/../tmp/#{@id}.crack"
            crack.outfile_format = 5
            # Status Output
            crack.status = true
            crack.status_timer = 30

            # Disable Restore and Pot File (not needed)
            crack.disable_restore = true
            crack.disable_potfile = true

            # Rules
            if @rule
              crack.rules = @rule
            end

            # Runtime limit
            if @runtime
              crack.runtime = @runtime
            end

            # Contains Username
            if @username
              crack.username = true
            end

            crack.attack_mode = @attack

            crack.hash = @hash

            # Attack modes
            if @attack == 3 # Bruteforce/Mask
              # Check if charset exists
              raise RubyHashcat::Objects::Hash::InvalidMaskAttack unless @charset
              crack.charset = @charset
            elsif @attack == 0 # Dictionary
              crack.wordlist = @word_list
            elsif @attack == 1 # Combination
              # Check if there are 2 word lists for combination attack
              raise RubyHashcat::Objects::Hash::InvalidCombinationAttack unless @word_list.count == 2
              crack.wordlist = @word_list
            elsif @attack == 7 or @attack == 6 # Hybrid dictionary & mask
              # Check if a word list and charset exist
              raise RubyHashcat::Objects::Hash::InvalidHybridAttack unless @word_list and @charset
              if @char_word
                crack.charset = @charset
                crack.wordlist = @word_list
              else
                crack.wordlist = @word_list
                crack.charset = @charset
              end
            end

          end

          File.delete("#{path}/../tmp/.hashcat_#{@id}_pid") if File.exists?("#{path}/../tmp/.hashcat_#{@id}_pid")
        end
      end

      def clean
        path = File.dirname(__FILE__)
        File.delete("#{path}/../tmp/.hashcat_#{@id}_pid") if File.exists("#{path}/../tmp/.hashcat_#{@id}_pid")
        File.delete("#{path}/../tmp/#{@id}_output.txt") if File.exists("#{path}/../tmp/#{@id}_output.txt")
        File.delete("#{path}/../tmp/#{@id}_errors.txt") if File.exists("#{path}/../tmp/#{@id}_errors.txt")
        File.delete("#{path}/../tmp/#{@id}.crack") if File.exists?("#{path}/../tmp/#{@id}.crack")
      end

      def status
        path = File.dirname(__FILE__)
        arr = RubyHashcat::Parse.stdout("#{path}/../tmp/#{@id}_output.txt")[-1]
        err = File.read("#{path}/../tmp/#{@id}_errors.txt").chomp.strip
        {:data => arr, :errors => err}
      end

      def running?
        path = File.dirname(__FILE__)
        File.exists?("#{path}/../tmp/.hashcat_#{@id}_pid")
      end

      def results
        path = File.dirname(__FILE__)
        RubyHashcat::Parse.pot_file("#{path}/../tmp/#{@id}.crack")
      end

      def word_list=(value)
        @word_list = []
        if value.is_a? Array
          value.each do |x|
            raise RubyHashcat::Objects::Hash::InvalidHashFile unless File.exists?(x)
            @word_list << x
          end
        else
          raise RubyHashcat::Objects::Hash::InvalidHashFile unless File.exists?(value)
          @word_list << value
        end
      end

      def hash=(value)
        raise RubyHashcat::Objects::Hash::InvalidHashFile unless File.exists?(value)
        @hash = value
      end

      def type=(value)
        raise RubyHashcat::Objects::Hash::InvalidHashId unless value.is_a? Integer
        @type = value
      end

      def attack=(value)
        raise RubyHashcat::Objects::Hash::InvalidAttack unless value.is_a? Integer and [0,1,3,6,7].include?(value)
        @attack = value
      end

      def char_word=(value)
        @char_word = !!value
      end

      def rules=(value)
        list = Dir.entries("#{@path}/rules/")
        @rule = []
        if value.is_a? Array
          raise RubyHashcat::Objects::Hash::InvalidRule unless (value - list).empty?
          value.each do |x|
            @rule << "#{@path}/rules/#{x}"
          end
        else
          raise RubyHashcat::Objects::Hash::InvalidRule unless list.include?(value)
          @rule << "#{@path}/rules/#{value}"
        end
      end

      def max_runtime=(value)
        raise RubyHashcat::Objects::Hash::InvalidRuntime unless value.is_a? Integer and value >= 300
        @runtime = value
      end

      def username=(value)
        @username = !!value
      end

      def charset=(value)
        raise RubyHashcat::Objects::Hash::InvalidCharset unless value.match(/(\?[lasdu]{1})+/)
        @charset = value
      end

      # Exceptions
      class InvalidHashType < StandardError
        def message
          'Invalid Hash Type. Hash type must be an integer.'
        end
      end
        class InvalidHashFile < StandardError
          def message
            'Invalid Hash Type. Hash type must be an integer.'
          end
        end
      class InvalidHashWordList < StandardError
        def message
          'Invalid Word List File. Please check your post request'
        end
      end
      class InvalidRule < StandardError
        def message
          'Invalid Rule File. To view a list of rules, please check the documentation or GET /rules.json'
        end
      end
      class InvalidCharset < StandardError
        def message
          'Invalid Charset String. To view a list of charsets, please check the documentation.'
        end
      end
      class InvalidAttack < StandardError
        def message
          'Invalid Attack. To view a list of attacks, please check the documentation.'
        end
      end
      class InvalidHashId < StandardError
        def message
          'Invalid Hash ID. Hash ID must be an integer.'
        end
      end
      class InvalidHashCatLocation < StandardError
        def message
          'Invalid HashCat path. HashCat path must exist.'
        end
      end
      class InvalidRuntime < StandardError
        def message
          'Invalid HashCat runtime. Runtime must be an integer and greater or equal to 300.'
        end
      end
      class InvalidMaskAttack < StandardError
        def message
          'Invalid HashCat mask attack. You must specify a valid charset.'
        end
      end
      class InvalidHybridAttack < StandardError
        def message
          'Invalid HashCat hybrid attack. You must specify a valid charset and word list.'
        end
      end
      class InvalidCombinationAttack < StandardError
        def message
          'Invalid HashCat combination attack. You must specify an array of 2 word lists.'
        end
      end
      class HashIDAlreadyExists < StandardError
        def message
          'The ID you chose for this hash already exists. Please choose another.'
        end
      end

      class Async
        include ::SuckerPunch::Job
        workers 3

        def crack(obj)
          obj.crack
        end

      end
    end
  end
end