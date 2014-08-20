class File
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
      end while lines < ( n + 1 ) && pos != 0

      tail_of_file = chunks.join('')
      ary = tail_of_file.split(/\n/)
      ary[ ary.size - n, ary.size - 1 ]
    rescue Errno::EINVAL => e
      ary = []
      each_line do |line|
        ary << line
      end
      ary
    end
  end

  def self.tail(file, num=10)
    arr = []
    return arr unless File.exists?(file)
    File.open(file) do |x|
      arr = x.tail(num)
    end
    arr
  end

  def self.touch(file)
    File.open(file, 'w') {}
  end

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