TREE = '#'
$field = File.readlines('input').map { |line| line.strip().chars }

def traverse(definition)
    dx_array = definition[0]
    dy_array = definition[1]

    raise "dx_array and dy_array must be of equal length" unless dx_array.count == dy_array.count

    depth = $field.count
    width = $field[0].count
    slopes = dx_array.count
    
    x_array = Array.new(slopes, 0)
    y_array = Array.new (slopes, 0)
    trees_array = Array.new(slopes, 0)

    until y_array.all? { |y| y >= depth } do
        for i in 0..slopes-1
            if y_array[i] >= depth then next end

            if $field[y_array[i]][x_array[i]] == TREE then trees_array[i] += 1 end
            y_array[i] += dy_array[i]
            x_array[i] = (x_array[i] + dx_array[i]) % width
        end
    end

    return trees_array.reduce(:*)
end

problem1 = [
    [3],
    [1]
]

problem2 = [
    [1, 3, 5, 7, 1],
    [1, 1, 1, 1, 2]
]

puts "Problem 1: #{traverse(problem1)}"
puts "Problem 2: #{traverse(problem2)}"