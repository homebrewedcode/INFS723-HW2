require 'openssl'

# Decrypt the class provided file, with the also provided key and IV values
decipher = OpenSSL::Cipher.new('AES-192-CBC')
decipher.decrypt
# We need to designate the strings as hex values
decipher.key = "\x02\x94\xE7\x14\x3C\x2D\xF1\x35\xDA\xEF\xE9\xD7\x4D\xF8\xBD\xCC\x48\x8E\xDB\xA8\xFE\x52\x39\xA8"
decipher.iv = "\xF3\xBC\x6E\x5B\x28\x1E\xBF\x67\x21\x0C\xD6\x88\x37\xFF\xDE\x9A"

# Read in the encrypted file contents, decrypt the value,
# then print it out to the screen as well as write to file.
# Note that decipher.final part is required
# to handle the necessary padding in the encryption format we are decrypting.
contents = IO.binread('cipher.txt')
plain = decipher.update(contents) + decipher.final
File.open("plain.txt", "w") {|f| f.write plain}

