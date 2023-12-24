data = readlines("./solutions/day23/input.txt")
# data = readlines("./solutions/day23/test_input.txt")

type_dict = Dict(
    '#' => 0,
    '.' => 1,
    '>' => 2,
    'v' => 3,
)

mutable struct Tile
    type::Int
    visited::Bool
end

function parse_data(data::Vector{String})
    tiles = Dict{CartesianIndex{2}, Tile}()
    for (y, line) in enumerate(data)
        for (x, char) in enumerate(line)
            tiles[CartesianIndex((x,y))] = Tile(type_dict[char], false)
        end
    end
    return tiles
end 

function print_tiles(tiles::Dict{CartesianIndex{2}, Tile})
    for y in 1:maximum([x[2] for x in keys(tiles)])
        for x in 1:maximum([x[1] for x in keys(tiles)])
            if tiles[CartesianIndex((x,y))].visited
                print("O")
            else
                if tiles[CartesianIndex((x,y))].type == 0
                    print("#")
                elseif tiles[CartesianIndex((x,y))].type == 1
                    print(".")
                elseif tiles[CartesianIndex((x,y))].type == 2
                    print(">")
                elseif tiles[CartesianIndex((x,y))].type == 3
                    print("v")
                end
            end
        end
        println()
    end
end

function move_and_count(count::Int, position::CartesianIndex{2}, target_position::CartesianIndex{2}, visited::Vector{CartesianIndex{2}}, tiles::Dict{CartesianIndex{2}, Tile})
    push!(visited, position)
    count += 1
    if position == target_position
        return count
    end

    if tiles[position].type == 1
        possible_directions = [CartesianIndex((0,1)), CartesianIndex((1,0)), CartesianIndex((0,-1)), CartesianIndex((-1,0))]
    elseif tiles[position].type == 2
        possible_directions = [CartesianIndex((1,0))]
    elseif tiles[position].type == 3
        possible_directions = [CartesianIndex((0,1))]
    end

    max_count = 0
    for possible_direction in possible_directions
        if position[1] + possible_direction[1] < x_min || position[1] + possible_direction[1] > x_max || position[2] + possible_direction[2] < y_min || position[2] + possible_direction[2] > y_max
            continue
        elseif position + possible_direction in visited
            continue
        elseif tiles[position + possible_direction].type == 0
            continue
        else
            local_count = move_and_count(count, position + possible_direction, target_position, copy(visited), tiles)
            if local_count > max_count
                max_count = local_count
            end
        end
    end
    count = max_count
    return count
end

# Part 1

tiles = parse_data(data)
print_tiles(tiles)
visited = Vector{CartesianIndex{2}}()
x_min = minimum([x[1] for x in keys(tiles)])
x_max = maximum([x[1] for x in keys(tiles)])
y_min = minimum([x[2] for x in keys(tiles)])
y_max = maximum([x[2] for x in keys(tiles)])

count = move_and_count(0,CartesianIndex((2,1)), CartesianIndex((x_max-1,y_max)), visited, tiles)

part1_ans = count - 1

# Part 2

function move_and_count_part2(count::Int, position::CartesianIndex{2}, target_position::CartesianIndex{2}, visited::Vector{CartesianIndex{2}}, tiles::Dict{CartesianIndex{2}, Tile})
    push!(visited, position)
    count += 1
    if position == target_position
        return count
    end

    possible_directions = [CartesianIndex((0,1)), CartesianIndex((1,0)), CartesianIndex((0,-1)), CartesianIndex((-1,0))]

    max_count = 0
    for possible_direction in possible_directions
        if position[1] + possible_direction[1] < x_min || position[1] + possible_direction[1] > x_max || position[2] + possible_direction[2] < y_min || position[2] + possible_direction[2] > y_max
            continue
        elseif position + possible_direction in visited
            continue
        elseif tiles[position + possible_direction].type == 0
            continue
        else
            local_count = move_and_count_part2(count, position + possible_direction, target_position, copy(visited), tiles)
            if local_count > max_count
                max_count = local_count
            end
        end
    end
    count = max_count
    return count
end

tiles = parse_data(data)
print_tiles(tiles)
visited = Vector{CartesianIndex{2}}()
x_min = minimum([x[1] for x in keys(tiles)])
x_max = maximum([x[1] for x in keys(tiles)])
y_min = minimum([x[2] for x in keys(tiles)])
y_max = maximum([x[2] for x in keys(tiles)])
count = move_and_count_part2(0,CartesianIndex((2,1)), CartesianIndex((x_max-1,y_max)), visited, tiles)

part1_ans = count - 1
