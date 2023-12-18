data = readlines("./solutions/day18/input.txt")
# data = readlines("./solutions/day18/test_input.txt")

struct entry
    direction::Vector{Int}
    distance::Int
    color::String
end

function parse_data(data::Vector{String})
    output = Vector{entry}()
    for line in data
        direction, distance, color = split(line, " ")
        push!(output, entry(direction_dict[direction], parse(Int,distance), color))
    end
    return output
end

input = parse_data(data)

function get_length(input::Matrix{Int})
    return sum(abs.(input[1, :] - input[2,:]))
end

line_collection = Vector{Matrix{Int}}()
current = [0, 0]
for line in input
    print(current, " ", current+line.direction*line.distance, "\n")
    push!(line_collection, hcat(current,current+line.direction*line.distance)')
    current += line.direction*line.distance
end

# Shoelace algorithm + perimeter + origin
part1_ans = sum(det.(line_collection))/2 + sum(get_length.(line_collection))/2+1

