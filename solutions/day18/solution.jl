data = readlines("./solutions/day18/input.txt")
# data = readlines("./solutions/day18/test_input.txt")

struct entry
    direction::Vector{Int}
    distance::Int
    color::String
end

direction_dict_letter = Dict("R"=>[1,0], "D" => [0, 1], "L" => [-1, 0], "U" => [0, -1])

function parse_data(data::Vector{String})
    output = Vector{entry}()
    for line in data
        direction, distance, color = split(line, " ")
        push!(output, entry(direction_dict_letter[direction], parse(Int,distance), color))
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
part1_ans = round(sum(det.(line_collection))/2 + sum(get_length.(line_collection))/2+1)

# Part 2

direction_dict = Dict(0=>[1,0], 1 => [0, 1], 2 => [-1, 0], 3 => [0, -1])

function process_hex(string::String)
    length = parse(Int, string[3:7], base=16)
    return length, direction_dict[parse(Int, string[8])]
end

instruction = map(x->process_hex(x.color), input)

function make_matrix(instruction::Vector{Tuple{Int,Vector{Int}}})
    line_collection = Vector{Matrix{Int}}()
    current = [0, 0]
    for line in instruction
        push!(line_collection, hcat(current,current+line[2]*line[1])')
        current += line[2]*line[1]
    end
    return line_collection
end

line_collection = make_matrix(instruction)

part2_ans = round(sum(det.(line_collection))/2 + sum(get_length.(line_collection))/2+1)