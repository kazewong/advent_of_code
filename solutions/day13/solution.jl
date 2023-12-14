data = readlines("./solutions/day13/input.txt")
# data = readlines("./solutions/day13/test_input.txt")

pattern_dict = Dict('#' => 1, '.' => 0)

function parse_data(data::Vector{String})
    groups = Vector{Matrix{Int}}()
    current_group = Vector{Vector{Int}}()
    for (index, line) in enumerate(data)
        if data[index] == ""
            current_group = hcat(current_group...)
            push!(groups, current_group)
            current_group = Vector{Vector{Int}}()
        elseif index == length(data)
            push!(current_group, map(x->pattern_dict[x], collect(data[index])))
            current_group = hcat(current_group...)
            push!(groups, current_group)
        else
            push!(current_group, map(x->pattern_dict[x], collect(data[index])))
        end
    end
    return groups
end

patterns = parse_data(data)

# Part 1

function check_reflection(start_row::Int, reflection_line::Int,pattern::AbstractMatrix)
    pattern_length = reflection_line - start_row # There is a hidden + 1 
    other_side = reflection_line + 1 + pattern_length
    if other_side > size(pattern, 1)
        return false
    elseif start_row != 1 && other_side != size(pattern, 1)
        return false
    end
    return all(pattern[start_row:reflection_line, :] .== pattern[other_side:-1:reflection_line+1, :])
end

function check_pattern(pattern::AbstractMatrix)
    for row in 1:size(pattern, 1)-1
        for reflection_line in row: row+(size(pattern, 1)-row)÷2
            if check_reflection(row, reflection_line, pattern)
                return reflection_line
            end
        end
    end
    return false
end

part1_ans = sum(map(x->check_pattern(x), patterns)) + sum(map(x->check_pattern(x'), patterns))*100

# Part 2

function check_reflection_smudge(start_row::Int, reflection_line::Int,pattern::AbstractMatrix)
    pattern_length = reflection_line - start_row # There is a hidden + 1 
    other_side = reflection_line + 1 + pattern_length
    if other_side > size(pattern, 1)
        return false
    elseif start_row != 1 && other_side != size(pattern, 1)
        return false
    end
    return count(==(0),pattern[start_row:reflection_line, :] .== pattern[other_side:-1:reflection_line+1, :]) == 1
end

function check_pattern_smudge(pattern::AbstractMatrix)
    for row in 1:size(pattern, 1)-1
        for reflection_line in row: row+(size(pattern, 1)-row)÷2
            if check_reflection_smudge(row, reflection_line, pattern)
                return reflection_line
            end
        end
    end
    return false
end

part1_ans = sum(map(x->check_pattern_smudge(x), patterns)) + sum(map(x->check_pattern_smudge(x'), patterns))*100
