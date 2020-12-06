require 'set'

def generate_seat_id(row, column)
    return (row * 8) + column
end

all_seat_ids = Hash.new

(0..127).each do |row|
    (0..7).each do |column|
        all_seat_ids[generate_seat_id(row, column)] = { :row => row, :column => column }
    end
end

def status_report(front, back, left, right)
    puts "FRONT #{front} BACK #{back} LEFT #{left} RIGHT #{right}"
end

def find_seat(spec)
    front = 0
    back = 127
    left = 0
    right = 7

    # status_report(front, back, left, right)

    spec.chars.each do |instruction|
        case instruction
        when 'F'
            back = ((back + front) / 2.0).to_i
            # status_report(front, back, left, right)
        when 'B'
            front = ((back + front) / 2.0).round
            # status_report(front, back, left, right)
        when 'L'
            right = ((right + left) / 2.0).to_i
            # status_report(front, back, left, right)
        when 'R'
            left = ((right + left) / 2.0).round
            # status_report(front, back, left, right)
        end
    end

    raise "You fucked up." unless (front == back && left == right)

    return generate_seat_id(front, left)
end

# ['FBFBBFFRLR', 'BFFFBBFRRR', 'FFFBBBFRRR', 'BBFFBBFRLL'].each { |spec| find_seat(spec) }

seat_ids = File.readlines('input').map { |spec| find_seat(spec) }.to_set
possible_seats = all_seat_ids.select { |id, v| !seat_ids.include?(id) }
puts "Problem 1: #{seat_ids.max}"
puts "Problem 2: #{possible_seats.keep_if { |id, v| seat_ids.include?(id + 1) && seat_ids.include?(id - 1)}}"