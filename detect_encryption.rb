require './DetectEncryption'
puts '___________                                          __   .__
 \_   _____/  ____    ____  _______  ___.__.______  _/  |_ |__|  ____    ____
  |    __)_  /    \ _/ ___\ \_  __ \<   |  |\____ \ \   __\|  | /  _ \  /    \
  |        \|   |  \\  \___  |  | \/ \___  ||  |_> > |  |  |  |(  <_> )|   |  \
 /_______  /|___|  / \___  > |__|    / ____||   __/  |__|  |__| \____/ |___|  /
         \/      \/      \/          \/     |__|                            \/
 ________             __                     __
 \______ \    ____  _/  |_   ____    ____  _/  |_   ____  _______
  |    |  \ _/ __ \ \   __\_/ __ \ _/ ___\ \   __\ /  _ \ \_  __ \
  |    `   \\  ___/  |  |  \  ___/ \  \___  |  |  (  <_> ) |  | \/
 /_______  / \___  > |__|   \___  > \___  > |__|   \____/  |__|
         \/      \/             \/      \/'

puts "\n\n***************************************************************************"
puts "*                   Welcome to the Encrytion Detector                     *"
puts "*         This tool will attempt to detect if a file is encrypted         *"
puts "*    This is accomplished by using the Linux 'file' command as well as    *"
puts "*               checking file entropy in two different ways               *"
puts "***************************************************************************"

puts "\n\nPlease type the path/filename you would like to check:"
filename = gets.chomp

puts "\n=================================================================================="
puts "The below is the output from the unix 'file' command."
puts "This will output the header information of the file if it can be detected."
puts "If information is gathered here (other than simply 'data'),"
puts "the file is likely not encrypted."
puts "The caveat is that some encrypted files actually have a header."
puts "==================================================================================\n\n"

entropy = DetectEncryption.new(filename)
puts entropy.header_info

puts "\n=================================================================================="
puts "This test will check the entropy of the first 512 bytes of the file,"
puts "(or the entire file if it is smaller)."
puts "Entropy max value will be 8, and values closer to this will likely be encrypted"
puts "We will consider any file over 6.5 entropy to be encrypted."
puts "==================================================================================\n\n"


file_entropy = entropy.entropy
encrypted_status = file_entropy >= 6.5 ? "encrypted" : "not encrypted"
puts "File entropy is #{file_entropy}.  The file is likely #{encrypted_status}."

puts "\n=================================================================================="
puts "The final check compresses the file and checks for the difference in file size"
puts "between the original file and the zipped file."
puts "A file that cannot be considerably reduced in size is likely encrypted."
puts "We will consider any file with a reduction ratio of greater that 95% to be encrpyted."
puts "Files less that 1k will not be considered, as they are too small for this test."
puts "==================================================================================\n\n"

reduction_ratio = entropy.zip_test_ratio
encrypted_status = reduction_ratio >= 0.95 ? "encrypted" : "not encrypted"
if reduction_ratio < 0
  puts "File is too small for this test."
elsif puts "The file reduction ratio is #{reduction_ratio}.  The file is likely #{encrypted_status}."

end



