def calculateValidPasswords(input, validDefinition)
    regex = /(\d+)-(\d+) (\w): (\w+)/

    numValidPasswords = 0

    input.each do |line|
        data = regex.match(line)

        if (method(validDefinition).call(data[1].to_i(), data[2].to_i(), data[3], data[4])) then
            numValidPasswords += 1
        end
    end

    return numValidPasswords
end

def problemOneDefinition(min, max, expect, password)
    charMap = Hash.new(0)

    password.chars.each { |char| charMap[char] += 1 }

    return charMap[expect] >= min && charMap[expect] <= max
end

def problemTwoDefinition(first, last, expect, password)
    return (password.chars[first - 1] == expect) ^ (password.chars[last - 1] == expect)
end

# test
test_input = [
    "1-3 a: abcde",
    "1-3 b: cdefg",
    "2-9 c: ccccccccc"
]

input = File.readlines('input')

puts "Test 1: #{calculateValidPasswords(test_input, :problemOneDefinition)}"
puts "Problem 1: #{calculateValidPasswords(input, :problemOneDefinition)}"
puts "Test 2: #{calculateValidPasswords(test_input, :problemTwoDefinition)}"
puts "Problem 2: #{calculateValidPasswords(input, :problemTwoDefinition)}"