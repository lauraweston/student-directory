file = __FILE__
File.open(file, "r") do |file|
  puts file.readlines
end
