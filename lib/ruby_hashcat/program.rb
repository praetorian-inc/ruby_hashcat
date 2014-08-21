require 'rprogram/program'

###########################################################################
# Author:                                                 Coleton Pierson #
# Company:                                                     Praetorian #
# Date:                                                     June 28, 2014 #
# Project:                                                   Ruby Hashcat #
# Description:          Main program wrapper class. Holds the main method #
#                       for initializing a cli session.                   #
###########################################################################

module RubyHashcat
  class Program < RProgram::Program

    # Add a top-level method which finds and runs the program.
    def self.crack(options={}, &block)
      self.find.crack(options, &block)
    end

    # Add a method which runs the program with hashcat_task
    def crack(options={}, &block)
      run_task(HashcatTask.new(options, &block))
    end

  end
end