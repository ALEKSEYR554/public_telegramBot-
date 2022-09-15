a=[]
File.readlines('code_to_full.txt').each do |line|
  a << line.split(" ")[0]
end
File.open("codes_only.txt", "w+") do |f|
  f.puts(a.uniq) end
