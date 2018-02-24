# INFS-723 Cryptography Homework 2
This tool has two parts.  The first part of the tool found in detect_encryption.rb runs
an analysis on a file to determine if it is encrypted or not.  The second part of the tool, 
simply decrypts the provided ciphter.txt file, which is AES encrypted. 

Resources for installing rails (linux assumed):

https://www.ruby-lang.org/en/downloads/

https://rvm.io/rvm/install



STEPS:

Make sure Ruby is installed, I used version 2.5.0, though recent ones will likely work

1.  Clone Repository: git clone https://github.com/homebrewedcode/INFS723-HW2.git
2.  Change Directories into cloned folder: cd INFS723-HW2
3.  Install bundler gem: gem install bundler
4.  Run bundler to install dependencies: bundle install
5.  For the Encryption Detection script: ruby detect_encryption.rb
6.  For the decipher encrypted file script: ruby decrypt_file.rb
7.  Open the plain.txt file, this command assuming vim: vim plain.txt