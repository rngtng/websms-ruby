require 'rubygems'

def convert(file)
  output = ""
  ::File.open(file).each do |line|
    line.size.times do |i|
      s = line[i]
      s = s.strip if s != "\t" && s != " "
      output << s
    end
    output << "\n"
  end
  
  ::File.open(file, 'w') do |f|
    f.puts output
  end
end

convert(ARGV[0])