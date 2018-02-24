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

  def build_frequency_list
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

  def calculate_entropy
    entropy = 0.0
    @char_frequency.each do |frequency|
      entropy += frequency * Math.log(frequency, 2) if frequency.positive?
    end
    @entropy = entropy * -1
  end

  def generate_header_info
    magic = FileMagic.new
    @header_info = magic.file(@file_name)
    magic.close

    @header_info
  end

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