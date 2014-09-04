path = File.dirname(__FILE__)
require "#{path}/tools"

###########################################################################
# Author:                                                 Coleton Pierson #
# Company:                                                     Praetorian #
# Date:                                                   August 20, 2014 #
# Project:                                                   Ruby Hashcat #
# Description:         Main parser class. Parses ocl stdout and pot file. #
###########################################################################

module RubyHashcat
  module Parse

    ###########################################################################
    # @method                                 RubyHashcat::Parse.stdout(file) #
    # @param file:                    [String] Path to oclHashcat stdout file #
    # @description             Parses the oclHashcat stdout file into hashes. #
    # @return           [Array][Hash] Array of Hashes with oclHashcat status. #
    ###########################################################################
    def self.stdout(file)
      array = []
      return array unless File.exists?(file)
      placement = -1
      string = []
      File.open(file).each_line do |x|
        string << x
      end
      string.each do |line|
        if line.include?('Session.Name.')
          placement += 1
          array[placement] = {}
        elsif  placement < 0
          next
        elsif line.include?('Status.')
          tmp = line.split(':')
          array[placement][:status] = tmp[-1].chomp.strip
        elsif line.include?('Rules.Type.')
          tmp = line.split(':')
          array[placement][:rules] = tmp[-1].chomp.strip
        elsif line.include?('Input.Mode.')
          tmp = line.split(':')
          array[placement][:input] = tmp[-1].chomp.strip
        elsif line.include?('Input.Base.')
          # Label only used in combination attack
          tmp = line.split(':')
          array[placement][:input_base] = tmp[-1].chomp.strip
        elsif line.include?('Input.Mod.')
          # Label only used in combination attack
          tmp = line.split(':')
          array[placement][:input_mod] = tmp[-1].chomp.strip
        elsif line.include?('Hash.Target.')
          tmp = line.split(':')
          array[placement][:target] = tmp[-1].chomp.strip
        elsif line.include?('Hash.Type.')
          tmp = line.split(':')
          array[placement][:type] = tmp[-1].chomp.strip
        elsif line.include?('Time.Started.')
          tmp = line.split(':')
          tmp.delete_at(0)
          tmp = tmp.join(':')
          array[placement][:started] = tmp.chomp.strip
        elsif line.include?('Time.Estimated.')
          tmp = line.split(':')
          tmp.delete_at(0)
          tmp = tmp.join(':')
          array[placement][:estimated] = tmp.chomp.strip
        elsif line.include?('Speed.GPU.')
          # Must account for x amount of GPUs
          tmp = line.split(':')
          tmp[0].gsub!('Speed.GPU.', '')
          tmp[0].gsub!('.', '')
          tmp[0].gsub!('#', '')
          num = tmp[0].to_i
          if num == 1
            array[placement][:speed] = []
          end
          array[placement][:speed][num-1] = tmp[-1].chomp.strip
        elsif line.include?('Recovered.')
          tmp = line.split(':')
          array[placement][:recovered] = tmp[-1].chomp.strip
        elsif line.include?('Progress.')
          tmp = line.split(':')
          array[placement][:progress] = tmp[-1].chomp.strip
        elsif line.include?('Rejected.')
          tmp = line.split(':')
          array[placement][:rejected] = tmp[-1].chomp.strip
        elsif line.include?('HWMon.GPU.')
          # Must account for x amount of GPUs
          tmp = line.split(':')
          tmp[0].gsub!('HWMon.GPU.', '')
          tmp[0].gsub!('.', '')
          tmp[0].gsub!('#', '')
          num = tmp[0].to_i
          if num == 1
            array[placement][:hwmon] = []
          end
          array[placement][:hwmon][num-1] = tmp[-1].chomp.strip
        end
      end
      array
    end


    ###########################################################################
    # @method                         RubyHashcat::Parse.status_automat(file) #
    # @param file:                    [String] Path to oclHashcat stdout file #
    # @description        Parses the oclHashcat status-automat stdout format. #
    # @return           [Array][Hash] Array of Hashes with oclHashcat status. #
    ###########################################################################
    def self.status_automat(file)
      array = []
      return array unless File.exists?(file)
      string = []
      File.open(file).each_line do |x|
        string << x
      end
      string.each do |line|
        line = line.chomp
        line = line.strip
        line = line.gsub('  ', ' ')
        unless line.include?('STATUS')
          next
        end
        split = line.split(' ')
        stat = {}
        i = 0
        if split[i] == 'STATUS'
          stat[:status] = split[i+1].chomp.strip
          i += 2
        end
        if split[i] == 'SPEED'
          i += 1
          speed = 0
          si = 0
          while split[i] != 'CURKU'
            calc = split[i].to_f
            duration = split[i+1].to_f
            if calc == 0.0 and duration == 0.0
              stat["speed_gpu_#{si+1}".to_sym] = 0
            else
              stat["speed_gpu_#{si+1}".to_sym] = (calc/duration).round
              speed += (calc/duration).round
            end
            si += 1
            i += 2
          end
          stat[:total_speed] = speed
        end
        if split[i] == 'CURKU'
          stat[:checkpoint] = split[i+1]
          i += 2
        end
        if split[i] == 'PROGRESS'
          current_prog = split[i+1].to_f
          total_prog = split[i+2].to_f
          stat[:progress] = ((((current_prog + 0.0)/(total_prog + 0.0)) * 10000).round)/10000.0
          i += 3
        end
        if split[i] == 'RECHASH'
          rec_count = split[i+1].to_f.to_i
          rec_total = split[i+2].to_f.to_i
          stat[:rec_hash] = "#{rec_count}/#{rec_total}"
          i += 3
        end
        if split[i] == 'RECSALT'
          rec_count = split[i+1].to_f.to_i
          rec_total = split[i+2].to_f.to_i
          stat[:rec_salt] = "#{rec_count}/#{rec_total}"
          i += 3
        end
        if split[i] == 'TEMP'
          i += 1
          si = 0
          while i < split.count
            stat["temp_gpu_#{si+1}".to_sym] = split[i].to_i
            si += 1
            i += 1
          end
        end
        array << stat
      end
      array
    end

    ###########################################################################
    # @method                               RubyHashcat::Parse.pot_file(file) #
    # @param file:              [String] Path to oclHashcat cracked passwords #
    # @description                  Parses the cracked passwords into a hash. #
    # @return           [Array][Hash] Array of Hashes with cracked passwords. #
    ###########################################################################
    def self.pot_file(file)
      arr = []
      return arr unless File.exists?(file)
      File.open(file).each_line do |x|
        split = x.split(':')
        plain = self.hex_to_bin(split[-1])
        split.delete_at(-1)
        hash = split.join(':')
        arr << {:hash => hash, :plain => plain}
      end
      arr
    end

    ###########################################################################
    # @method                                   RubyHashcat::Parse.hash(hash) #
    # @param hash:                 [Hash] Original Hash with strings as keys. #
    # @description       Parses a hash with strings as keys and converts them #
    #                    to symbols.                                          #
    # @return                           [Hash] Hash with all keys as symbols. #
    ###########################################################################
    def self.hash(obj)
      return obj.reduce({}) do |memo, (k, v)|
        memo.tap { |m| m[k.to_sym] = hash(v) }
      end if obj.is_a? Hash

      return obj.reduce([]) do |memo, v|
        memo << hash(v); memo
      end if obj.is_a? Array

      obj
    end

    ###########################################################################
    # @method                                RubyHashcat::Parse.bin_to_hex(s) #
    # @param s:                                        [String] Normal String #
    # @description                                   Converts a string to hex #
    # @return                                           [String] Hexed String #
    ###########################################################################
    def self.bin_to_hex(s)
      s.each_byte.map { |b| b.to_s(16) }.join
    end

    ###########################################################################
    # @method                                RubyHashcat::Parse.hex_to_bin(s) #
    # @param s:                                         [String] Hexed String #
    # @description                                   Converts hex to a string #
    # @return                                          [String] Normal String #
    ###########################################################################
    def self.hex_to_bin(s)
      s.scan(/../).map { |x| x.hex.chr }.join
    end

  end
end