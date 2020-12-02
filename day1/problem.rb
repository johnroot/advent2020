require 'benchmark'

def getValue(l, h, num)
    return num[l] + num[h]
end

def getValue2(l, m, h, num)
    return num[l] + num[m] + num[h]
end

numbers = File.readlines('input.txt').map!(&:to_i)

# O(nlogn) sort
puts Benchmark.measure {
    puts "Sorting!"
    numbers.sort!()
}

# O(n) search
puts Benchmark.measure {
    low = 0
    hi = numbers.count - 1
    current_value = getValue(low, hi, numbers)

    while (current_value != 2020) do
        current_value > 2020 ? (hi -= 1) : (low += 1)
        current_value = getValue(low, hi, numbers)
    end

    puts "Task 1: #{numbers[low] * numbers[hi]}"
}

# O(n^2) search
puts Benchmark.measure {
    low = 0
   	hi = numbers.count - 1

    for mid in 1..numbers.count-2 do
        low = 0
        hi = numbers.count - 1

        current_value = getValue2(low, mid, hi, numbers)
        
        while (current_value != 2020) do
            current_value > 2020 ? (hi -= 1) : (low += 1)
            
            if (hi == mid || low == mid) then 
                break
            end

            current_value = getValue2(low, mid, hi, numbers)
        end

        if (current_value == 2020) then break end
    end

    puts "Task 2: #{numbers[low] * numbers[mid] * numbers[hi]}"
}
