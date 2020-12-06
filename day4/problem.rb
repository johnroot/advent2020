require 'set'

FIELD_REGEX = /(\w+):(\S*)/
YEAR_REGEX = /^\d{4}$/
BIRTH_YEAR = 'byr'
ISSUE_YEAR = 'iyr'
EXPIRATION_YEAR = 'eyr'
HEIGHT = 'hgt'
HAIR_COLOR = 'hcl'
EYE_COLOR = 'ecl'
PASSPORT_ID = 'pid'
REQUIRED_FIELDS = Set[BIRTH_YEAR, ISSUE_YEAR, EXPIRATION_YEAR, HEIGHT, HAIR_COLOR, EYE_COLOR, PASSPORT_ID]
VALID_EYE_COLORS = Set['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']

def validate_field(field, value)
    case field
    when BIRTH_YEAR
        return YEAR_REGEX.match?(value) && value.to_i >= 1920 && value.to_i <= 2002
    when ISSUE_YEAR
        return YEAR_REGEX.match?(value) && value.to_i >= 2010 && value.to_i <= 2020
    when EXPIRATION_YEAR
        return YEAR_REGEX.match?(value) && value.to_i >= 2020 && value.to_i <= 2030
    when HEIGHT
        heightData = /^(?<number>\d+)(?<units>in|cm)?/.match(value)
        height = heightData[:number].to_i
        case heightData[:units]
        when 'in'
            return height >= 59 && height <= 76
        when 'cm'
            return height >= 150 && height <= 193
        else
            return false
        end
    when HAIR_COLOR
        return /^#[a-f|0-9]{6}$/.match?(value)
    when EYE_COLOR
        return VALID_EYE_COLORS.include?(value)
    when PASSPORT_ID
        return /^\d{9}$/.match?(value)
    else
        return true
    end
end

def validate_passport(passport, validate_fields)
    return REQUIRED_FIELDS.all? { |field| passport.key?(field) && (validate_fields ? validate_field(field, passport[field]) : true) }
end

def process_input(input, validate_fields)
    valid_passports = 0
    current_passport = Hash.new()
    input.each do |line|
        if line.empty? then
            if validate_passport(current_passport, validate_fields) then valid_passports += 1 end
            current_passport.clear
        else
            # add the fields to the existing passport
            line.scan(FIELD_REGEX).each { |m| current_passport[m[0]] = m[1] }
        end
    end

    if current_passport.any? then
        if validate_passport(current_passport, validate_fields) then valid_passports += 1 end
    end

    return valid_passports
end

problem_one_test = [
    'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd',
    'byr:1937 iyr:2017 cid:147 hgt:183cm',
    '',
    'iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884',
    'hcl:#cfa07d byr:1929',
    '',
    'hcl:#ae17e1 iyr:2013',
    'eyr:2024',
    'ecl:brn pid:760753108 byr:1931',
    'hgt:179cm',
    '',
    'hcl:#cfa07d eyr:2025 pid:166559648',
    'iyr:2011 ecl:brn hgt:59in'
]

invalid_passports = [
    'eyr:1972 cid:100',
    'hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926',
    '',
    'iyr:2019',
    'hcl:#602927 eyr:1967 hgt:170cm',
    'ecl:grn pid:012533040 byr:1946',
    '',
    'hcl:dab227 iyr:2012',
    'ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277',
    '',
    'hgt:59cm ecl:zzz',
    'eyr:2038 hcl:74454a iyr:2023',
    'pid:3556412378 byr:2007'
]

valid_passports = [
    'pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980',
    'hcl:#623a2f',
    '',
    'eyr:2029 ecl:blu cid:129 byr:1989',
    'iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm',
    '',
    'hcl:#888785',
    'hgt:164cm byr:2001 iyr:2015 cid:88',
    'pid:545766238 ecl:hzl',
    'eyr:2022',
    '',
    'iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719'
]

field_validation_tests = [
    [BIRTH_YEAR, '2002', true],
    [BIRTH_YEAR, '2003', false],
    [HEIGHT, '60in', true],
    [HEIGHT, '190cm', true],
    [HEIGHT, '190in', false],
    [HEIGHT, '190', false],
    [HAIR_COLOR, '#123abc', true],
    [HAIR_COLOR, '#123abz', false],
    [HAIR_COLOR, '123abc', false],
    [EYE_COLOR, 'brn', true],
    [EYE_COLOR, 'wat', false],
    [PASSPORT_ID, '000000001', true],
    [PASSPORT_ID, '0123456789', false]
]

def test_field_validation(test_case)
    if validate_field(test_case[0], test_case[1]) != test_case[2] then
        puts "Test for #{test_case[0]} as #{test_case[1]} failed"
    end
end

input = File.readlines('input').map(&:chomp)

puts "Problem 1 Test (expects 2): #{process_input(problem_one_test, false)}"
puts "Problem 1: #{process_input(input, false)}"

field_validation_tests.each { |test_case| test_field_validation(test_case) }

puts "Problem 2 Test 1 (expects 0): #{process_input(invalid_passports, true)}"
puts "Problem 2 Test 2 (expects 4): #{process_input(valid_passports, true)}"
puts "Problem 2: #{process_input(input, true)}"