###########################################################################
# Author:                                                 Coleton Pierson #
# Company:                                                     Praetorian #
# Date:                                                   August 20, 2014 #
# Project:                                                   Ruby Hashcat #
# Description:            Main tool class. Useful extensions and methods. #
###########################################################################

class File
  ###########################################################################
  # @method                                                         tail(n) #
  # @param n:                                     [Integer] Number of lines #
  # @description                Implementation of tail for Ruby File class. #
  # @return                        [Array] Array of last n lines of a file. #
  ###########################################################################
  def tail(n)
    begin
      buffer = 1024
      idx = (size - buffer).abs
      chunks = []
      lines = 0

      begin
        seek(idx)
        chunk = read(buffer)
        lines += chunk.count("\n")
        chunks.unshift chunk
        idx -= buffer
      end while lines < (n + 1) && pos != 0

      tail_of_file = chunks.join('')
      ary = tail_of_file.split(/\n/)
      ary[ary.size - n, ary.size - 1]
    rescue Errno::EINVAL => e
      ary = []
      each_line do |line|
        ary << line
      end
      ary
    end
  end

  ###########################################################################
  # @method                                            File.tail(file, num) #
  # @param file:                                      [String] Path of File #
  # @param num:                                   [Integer] Number of lines #
  # @description                Implementation of tail for Ruby File class. #
  # @return                        [Array] Array of last n lines of a file. #
  ###########################################################################
  def self.tail(file, num=10)
    arr = []
    return arr unless File.exists?(file)
    File.open(file) do |x|
      arr = x.tail(num)
    end
    arr
  end

  ###########################################################################
  # @method                                                File.touch(file) #
  # @param file:                                      [String] Path of File #
  # @description               Implementation of touch for Ruby File class. #
  ###########################################################################
  def self.touch(file)
    File.open(file, 'w') {}
  end

  ###########################################################################
  # @method                                           File.shred(file, num) #
  # @param file:                                      [String] Path of File #
  # @param num:                              [Integer] Number of overwrites #
  # @description       Implementation of secure delete for Ruby File class. #
  # @return                            [Boolean] File shredded successfully #
  ###########################################################################
  def self.shred(filename, num=10)
    if File.exists?(filename)
      filesize = File.size(filename)
      num.times do
        [0x00, 0xff].each do |byte|
          File.open(filename, 'wb') do |fo|
            filesize.times { fo.print(byte.chr) }
          end
        end
      end
      File.delete(filename)
      return true
    else
      return false
    end
  end
end