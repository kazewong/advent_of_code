data = readlines("./solutions/day9/input.txt")
# data = readlines("./solutions/day9/test_input.txt")

input = map(x->parse.(Int, x), split.(data, " "))

# Part 1

function extrapolate(input::Vector{Int})
    diffs = diff(input)
    last_diff = 0
    if !all(diffs.==0)
        last_diff = extrapolate(diffs)
    end
    return last(input) + last_diff
end

part1_ans = sum(extrapolate.(input))

# Part 2

function extrapolate_backward(input::Vector{Int})
    diffs = diff(input)
    first_diff = 0
    if !all(diffs.==0)
        first_diff = extrapolate_backward(diffs)
    end
    return first(input) - first_diff
end

part2_ans = sum(extrapolate_backward.(input))