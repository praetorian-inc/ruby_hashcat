###########################################################################
# Author:                                                 Coleton Pierson #
# Company:                                                     Praetorian #
# Date:                                                   August 20, 2014 #
# Project:                                                   Ruby Hashcat #
# Description:            Main tool class. Useful extensions and methods. #
###########################################################################

class File
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