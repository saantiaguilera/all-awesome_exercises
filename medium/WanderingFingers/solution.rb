# Credits go to MatthewASobol! Catch him on -> https://www.reddit.com/user/MatthewASobol

words = []

File.open('enable1.txt', 'r') do |file|
    words = file.readlines.collect { |line| line.chomp }
    words.reject! { |word| word.size < 5 }
end

input = gets.chomp
first_char = input.chars[0]
last_char = input.chars[input.size - 1]

candidates =  words.select{ |word| word.start_with?(first_char)}
candidates.select!{ |word| word.end_with?(last_char) }

candidates.reject! do |word|
    index = 0
    word.chars.any? do |char|
        index = input.index(char, index)
        index.nil?
    end
end

puts candidates
