require 'sucker_punch'

###########################################################################
# Author:                                                 Coleton Pierson #
# Company:                                                     Praetorian #
# Date:                                                   August 20, 2014 #
# Project:                                                   Ruby Hashcat #
# Description:               Main hash class. Interfaces with cli wrapper #
#                            and processes async tasks.                   #
###########################################################################

module RubyHashcat
  module Objects
    class Hash

      ###########################################################################
      # @method                                            initialize(id, path) #
      # @param id:                                            [Integer] Hash ID #
      # @param path:                                   [String] oclHashcat Path #
      # @description                                     Initialize a new hash. #
      ###########################################################################
      def initialize(id, path)
        raise RubyHashcat::Objects::Hash::InvalidHashId unless id.is_a? Integer
        raise RubyHashcat::Objects::Hash::InvalidHashCatLocation unless Dir.exists?(File.dirname(path))
        @id = id
        @path = File.dirname(path)
        @ocl = path
      end

      ###########################################################################
      # @method                                                    crack(async) #
      # @param async:                                     [Boolean] Crack Async #
      # @description                  Crack the hash with the current settings. #
      ###########################################################################
      def crack(async=false)

        # Check if async
        if async
          # SuckerPunch the crack method
          RubyHashcat::Objects::Hash::Async.new.async.crack(self)
        else
          path = File.dirname(__FILE__)

          # Redirect standard output and errors for parsing
          $stdout.reopen("#{path}/../tmp/#{@id}_output.txt", 'w')
          $stderr.reopen("#{path}/../tmp/#{@id}_errors.txt", 'w')

          # Create PID file for this hash ID
          File.touch("#{path}/../tmp/.hashcat_#{@id}_pid")

          worker = RubyHashcat::Program.new(@ocl)

          # Start cracking with wrapper
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
            crack.rules = @rule if @rule

            # Runtime limit
            crack.runtime = @runtime if @runtime

            # Contains Username
            crack.username = true if @username

            if @attack == 1
              crack.rule_left = @left_rule if @left_rule
              crack.rule_right = @right_rule if @right_rule
            end

            crack.attack_mode = @attack

            crack.hash = @hash

            # Attack mode config
            case @attack
              when 0
                # Dictionary Attack
                crack.wordlist = @word_list
              when 1
                # Combination Attack
                raise RubyHashcat::Objects::Hash::InvalidCombinationAttack unless @word_list.count == 2
                crack.wordlist = @word_list
              when 3
                # Bruteforce/Mask Attack
                raise RubyHashcat::Objects::Hash::InvalidMaskAttack unless @charset
                crack.charset = @charset
              when 6
                # Hybrid Dict + Mask Attack
                raise RubyHashcat::Objects::Hash::InvalidHybridAttack unless @word_list and @charset
                crack.wordlist = @word_list
                crack.charset = @charset
              when 7
                # Hybrid Mask + Dict Attack
                raise RubyHashcat::Objects::Hash::InvalidHybridAttack unless @word_list and @charset
                crack.charset = @charset
                crack.wordlist = @word_list
              else
                raise RubyHashcat::Objects::Hash::InvalidAttack
            end

          end

          File.delete("#{path}/../tmp/.hashcat_#{@id}_pid") if File.exists?("#{path}/../tmp/.hashcat_#{@id}_pid")
        end
      end

      ###########################################################################
      # @method                                                           clean #
      # @description                     Deletes all files created by cracking. #
      ###########################################################################
      def clean
        path = File.dirname(__FILE__)
        File.delete("#{path}/../tmp/.hashcat_#{@id}_pid") if File.exists?("#{path}/../tmp/.hashcat_#{@id}_pid")
        File.delete("#{path}/../tmp/#{@id}_output.txt") if File.exists?("#{path}/../tmp/#{@id}_output.txt")
        File.delete("#{path}/../tmp/#{@id}_errors.txt") if File.exists?("#{path}/../tmp/#{@id}_errors.txt")
        File.delete("#{path}/../tmp/#{@id}.crack") if File.exists?("#{path}/../tmp/#{@id}.crack")
      end

      ###########################################################################
      # @method                                                          status #
      # @description             Reads oclHashcat output and parses the status. #
      # @return                              [Hash] Hash with status and errors #
      ###########################################################################
      def status
        path = File.dirname(__FILE__)
        if File.exists?("#{path}/../tmp/#{@id}_output.txt") and File.exists?("#{path}/../tmp/#{@id}_errors.txt")
          arr = RubyHashcat::Parse.stdout("#{path}/../tmp/#{@id}_output.txt")
          if arr.is_a? Array
            arr_dat = arr[-1]
          end
          err = File.read("#{path}/../tmp/#{@id}_errors.txt").chomp.strip
          {:data => arr_dat, :errors => err}
        else
          return false
        end
      end

      ###########################################################################
      # @method                                                        running? #
      # @description           Checks pid file to see if oclhashcat is running. #
      # @return                                    [Boolean] oclHashcat Running #
      ###########################################################################
      def running?
        path = File.dirname(__FILE__)
        File.exists?("#{path}/../tmp/.hashcat_#{@id}_pid")
      end

      ###########################################################################
      # @method                                                         exists? #
      # @description        Checks to see if the object has initiated cracking. #
      # @return                                                       [Boolean] #
      ###########################################################################
      def exists?
        path = File.dirname(__FILE__)
        File.exists?("#{path}/../tmp/#{@id}_output.txt")
      end

      ###########################################################################
      # @method                                                          status #
      # @description   Reads oclHashcat pot file and parses the cracked hashes. #
      # @return    [Hash] Returns cracked hashes and their plaintext passwords. #
      ###########################################################################
      def results
        path = File.dirname(__FILE__)
        RubyHashcat::Parse.pot_file("#{path}/../tmp/#{@id}.crack")
      end

      ####################
      # Modifier Methods #
      ####################

      ###########################################################################
      # @method                                               word_list=(value) #
      # @param value:                                   [Array] Word List Paths #
      #                                                 [String] Word List Path #
      # @description                                          Set word list(s). #
      ###########################################################################
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

      ###########################################################################
      # @method                                                    hash=(value) #
      # @param value:                                   [String] Hash File Path #
      # @description                                                  Set hash. #
      ###########################################################################
      def hash=(value)
        raise RubyHashcat::Objects::Hash::InvalidHashFile unless File.exists?(value)
        @hash = value
      end

      ###########################################################################
      # @method                                                    type=(value) #
      # @param value:                                       [Integer] Hash Type #
      # @description                                             Set hash type. #
      ###########################################################################
      def type=(value)
        raise RubyHashcat::Objects::Hash::InvalidHashId unless value.is_a? Integer
        @type = value
      end

      ###########################################################################
      # @method                                                  attack=(value) #
      # @param value:                                     [Integer] Attack Type #
      # @description                                           Set attack type. #
      ###########################################################################
      def attack=(value)
        raise RubyHashcat::Objects::Hash::InvalidAttack unless value.is_a? Integer and [0, 1, 3, 6, 7].include?(value)
        @attack = value
      end

      ###########################################################################
      # @method                                               char_word=(value) #
      # @param value:            [Boolean] Charset first in Hybrid attack order #
      # @description             Set attack order for hybrid attack to (charset #
      #                          + word list) instead of (word list + charset). #
      ###########################################################################
      def char_word=(value)
        @char_word = !!value
      end

      ###########################################################################
      # @method                                                   rules=(value) #
      # @param value:                                   [Array] Rule File Names #
      #                                                 [String] Rule File Name #
      # @description                   Set rules for word lists. Verifies rules #
      #                                are in the ocl rule folder (/ocl/rules). #
      ###########################################################################
      def rules=(value)
        list = Dir.entries("#{@path}/rules/")
        @rule = []
        if value.is_a? Array
          raise RubyHashcat::Objects::Hash::InvalidRuleFile unless (value - list).empty?
          value.each do |x|
            @rule << "#{@path}/rules/#{x}"
          end
        else
          raise RubyHashcat::Objects::Hash::InvalidRuleFile unless list.include?(value)
          @rule << "#{@path}/rules/#{value}"
        end
      end

      ###########################################################################
      # @method                                             max_runtime=(value) #
      # @param value:                                         [Integer] Seconds #
      # @description                         Set max time for cracking to last. #
      ###########################################################################
      def max_runtime=(value)
        raise RubyHashcat::Objects::Hash::InvalidRuntime unless value.is_a? Integer and value >= 300
        @runtime = value
      end

      ###########################################################################
      # @method                                                username=(value) #
      # @param value:                                        [Boolean] Username #
      # @description                 Set true if hash file contains user names. #
      ###########################################################################
      def username=(value)
        @username = !!value
      end

      ###########################################################################
      # @method                                                 charset=(value) #
      # @param value:                                          [String] Charset #
      # @description            Set charset for brute forcing or hybrid attack. #
      #                         Must follow oclHashcat's charset pattern:       #
      #                           ?l - lowercase                                #
      #                           ?u - uppercase                                #
      #                           ?d - digit                                    #
      #                           ?s - special                                  #
      #                           ?a - all                                      #
      ###########################################################################
      def charset=(value)
        raise RubyHashcat::Objects::Hash::InvalidCharset unless value.match(/(\?[lasdu]{1})+/)
        @charset = value
      end

      ###########################################################################
      # @method                                               left_rule=(value) #
      # @param value:                                          [String] Charset #
      # @description                  Set rules for left dict on hybrid attack. #
      ###########################################################################
      def left_rule=(value)
        raise RubyHashcat::Objects::Hash::InvalidRule unless value.match(/([:lucCtrdfq\{\}\[\]]{1})||(T[0-9]+)||(p[0-9]+)||(\$[0-9]+)||(\^[0-9]+)||(D[0-9]+)||(x[0-9]{2,})||(i[0-9]{2,})||(o[0-9]{2,})||('[0-9]+)||(s[0-9]{2,})||(@[0-9]+)||(z[0-9]+)||(Z[0-9]+)/) and value != ''
        @left_rule = value
      end

      ###########################################################################
      # @method                                              right_rule=(value) #
      # @param value:                                          [String] Charset #
      # @description                 Set rules for right dict on hybrid attack. #
      ###########################################################################
      def right_rule=(value)
        raise RubyHashcat::Objects::Hash::InvalidRule unless value.match(/([:lucCtrdfq\{\}\[\]]{1})||(T[0-9]+)||(p[0-9]+)||(\$[0-9]+)||(\^[0-9]+)||(D[0-9]+)||(x[0-9]{2,})||(i[0-9]{2,})||(o[0-9]{2,})||('[0-9]+)||(s[0-9]{2,})||(@[0-9]+)||(z[0-9]+)||(Z[0-9]+)/) and value != ''
        @right_rule = value
      end

      ####################
      # Class Exceptions #
      ####################
      class RubyHashcatError < StandardError
      end
      class InvalidHashType < RubyHashcatError
        def message
          'Invalid Hash Type. Hash type must be an integer.'
        end
      end
      class InvalidHashFile < RubyHashcatError
        def message
          'Invalid Hash File. Check your hash file.'
        end
      end
      class InvalidHashWordList < RubyHashcatError
        def message
          'Invalid Word List File. Please check your post request'
        end
      end
      class InvalidRuleFile < RubyHashcatError
        def message
          'Invalid Rule File. To view the default rule files packaged with hashcat, please check the documentation or GET /rules.json'
        end
      end
      class InvalidCharset < RubyHashcatError
        def message
          'Invalid Charset String. To view a list of valid charsets, please check the documentation.'
        end
      end
      class InvalidRule < RubyHashcatError
        def message
          'Invalid Rule. To view a list of valid rules, please check the documentation.'
        end
      end
      class InvalidAttack < RubyHashcatError
        def message
          'Invalid Attack. To view a list of attacks, please check the documentation.'
        end
      end
      class InvalidHashId < RubyHashcatError
        def message
          'Invalid Hash ID. Hash ID must be an integer.'
        end
      end
      class InvalidHashCatLocation < RubyHashcatError
        def message
          'Invalid HashCat path. HashCat path must exist.'
        end
      end
      class InvalidRuntime < RubyHashcatError
        def message
          'Invalid HashCat runtime. Runtime must be an integer and greater or equal to 300.'
        end
      end
      class InvalidMaskAttack < RubyHashcatError
        def message
          'Invalid HashCat mask attack. You must specify a valid charset.'
        end
      end
      class InvalidHybridAttack < RubyHashcatError
        def message
          'Invalid HashCat hybrid attack. You must specify a valid charset and word list.'
        end
      end
      class InvalidCombinationAttack < RubyHashcatError
        def message
          'Invalid HashCat combination attack. You must specify an array of 2 word lists.'
        end
      end
      class HashIDAlreadyExists < RubyHashcatError
        def message
          'The ID you chose for this hash already exists. Please choose another.'
        end
      end

      #########################
      # Sucker Punch Subclass #
      #########################
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