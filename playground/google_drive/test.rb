
require 'fileutils'

puts Dir.children("G:/マイドライブ")

FileUtils.copy("resources/test1.txt", "G:/マイドライブ/resources")