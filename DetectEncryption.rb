require 'filemagic'
require 'zip'

class DetectEncryption
  attr_accessor :header_info, :entropy, :file_size, :zip_test_ratio

  def initialize(file_name)
    @file_name = file_name
    @char_frequency = []
    @entropy_list = []
    @file_size = File.size(file_name)
    @byte_chunk = @file_size > 512 ? 512 : @file_size

    build_frequency_list
    calculate_entropy
    generate_header_info
    compress_file
  end

  # Builds a list of the frequency of each byte occurence in the file for the first 512 bytes.
  # From some testing, it seemed that beginning bytes in the file was the best for determining
  # entropy, even for binary files.  This is likely due to the readable material in the
  # header as well as the padding that frequently appears.
  def build_frequency_list
    # read the 512 byte chunk into the variable, get the size,
    # and count each value of the 256 possibilites.  Stored in @char_frequency
    file_stream = IO.binread(@file_name, @byte_chunk)
    block_size = file_stream.length * 1.0
    file_unpacked = file_stream.unpack('C*').map { |c| c.to_s }
    (0..255).each do |byte|
      counter = 0
      file_unpacked.each do |index|
        counter += 1 if index.to_i == byte
      end
      @char_frequency.insert(byte, counter / block_size)
    end
  end

  # Performs the math on the character frequency based on Shannons Entropy forumula
  # The number between 0-8 should represent the "randomness" of the file, with 8 being
  # totally random and 0 being entirely orderly.
  def calculate_entropy
    entropy = 0.0
    @char_frequency.each do |frequency|
      entropy += frequency * Math.log(frequency, 2) if frequency.positive?
    end
    @entropy = entropy * -1
  end

  # Gets the output from the unix 'file' command
  def generate_header_info
    magic = FileMagic.new
    @header_info = magic.file(@file_name)
    magic.close

    @header_info
  end

  # Compresses the provided filename and provides the ration of zipped / unzipped
  # File compression depends on lower entropy of the file, therefore if the file
  # cannot be significantly reduced in size by compression, it is likely encrypted.
  # The method cleans up the compressed file when complete.
  def compress_file
    folder = "./"
    zipfile_name = "./test_file.zip"

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      zipfile.add(@file_name, File.join(folder, @file_name))
    end

    zipped_size = File.size('test_file.zip')
    @zip_test_ratio = (zipped_size * 1.0) / @file_size
    @zip_test_ratio = -1 if @file_size < 1000

    File.delete("./test_file.zip")
  end

end