class TeeIO < IO
  def initialize(orig, file)
    @orig = orig
    @file = file
  end

  def write(string)
    @file.write string
    @orig.write string
  end
end