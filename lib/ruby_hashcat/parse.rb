path = File.dirname(__FILE__)
require "#{path}/file"
module RubyHashcat
  module Parse
      def self.stdout(file)
        array = []
        placement = -1
        string = File.tail(file, 30)
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

      def self.pot_file(file)
        arr = []
        File.open(file).each_line do |x|
          split = x.split(':')
          plain = self.hex_to_bin(split[-1])
          split.delete[-1]
          hash = split.join(':')
          arr << {:hash => hash, :plain => plain}
        end
        arr
      end

      def self.hash(obj)
        return obj.reduce({}) do |memo, (k, v)|
          memo.tap { |m| m[k.to_sym] = hash(v) }
        end if obj.is_a? Hash

        return obj.reduce([]) do |memo, v|
          memo << hash(v); memo
        end if obj.is_a? Array

        obj
      end

      def self.bin_to_hex(s)
        s.each_byte.map { |b| b.to_s(16) }.join
      end

      def self.hex_to_bin(s)
        s.scan(/../).map { |x| x.hex.chr }.join
      end

  end
end