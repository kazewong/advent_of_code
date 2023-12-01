data = readlines("./solutions/day1/input.txt")

# Part 1
rolling_sum = 0
for line in data
    current_line = []
    for char in line
        if isdigit(char)
            push!(current_line, char)
        end
    end
    rolling_sum += parse(Int, current_line[1]*last(current_line))
end

# Part 2

rolling_sum = 0

word_enum = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
number_enum = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
length_enum = length.(word_enum) # [3, 3, 5, 4, 4, 3, 5, 5, 4] Copilot did this for me

for line in data
    current_line = []
    for index in eachindex(line)
        if isdigit(line[index])
            push!(current_line, line[index])
        else
            for j_index in 1:9
                if index+length_enum[j_index]-1 <= length(line)
                    # println(j_index,line[index:index+length_enum[j_index]-1])
                    if occursin(word_enum[j_index], line[index:index+length_enum[j_index]-1])
                        push!(current_line, number_enum[j_index][1])
                    end
                end
            end
        end
    end
    println(parse(Int, current_line[1]*last(current_line)))
    rolling_sum += parse(Int, current_line[1]*last(current_line))
end