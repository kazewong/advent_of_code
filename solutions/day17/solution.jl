using Revise
using DataStructures

# data = readlines("./solutions/day17/input.txt")
data = readlines("./solutions/day17/test_input.txt")

struct Tile
    location::Vector{Int}
    loss::Int
    visited::Bool
    distance::Number
    direction::Vector{Int}
end

function parse_data(data::Vector{String})
    output = Dict{Vector{Int},Tile}()
    for (index, line) in enumerate(data)
        for (index2, char) in enumerate(line)
            output[[index2, index]] = Tile([index2, index], parse(Int, char), false, Inf, [0, 0])
        end
    end
    return output
end

function zfill(str::AbstractString, width::Int)
    if width <= length(str)
        return str
    else
        return " "^(width - length(str)) * str
    end
end

# Part 1

function check_neighbors(tile1::Tile, tile2::Vector{Tile})
    if any(map(x -> sum(abs.(tile1.location - x.location)), tile2) .== 1)
        return true
    else
        return false
    end
end

function check_neighbors(tile1::Tile, tile2::Tile)
    if sum(abs.(tile1.location - tile2.location)) == 1
        return true
    else
        return false
    end
end

function update_neighbors!(tile::Tile, grid::Dict{Vector{Int},Tile})
    neighbor_tile = filter(x -> check_neighbors(tile, x[2]), collect(grid))
    new_neighbors = Vector{Tile}()
    for neighbor in neighbor_tile
        # if neighbor[2].visited == false
            diff = neighbor[2].location - tile.location
            new_distance = tile.distance + neighbor[2].loss
            if (maximum(tile.direction+diff) < 4) && (new_distance < neighbor[2].distance)
                if maximum(abs.(tile.direction + diff)) > maximum(abs.(tile.direction)) 
                    grid[neighbor[2].location] = Tile(neighbor[2].location, neighbor[2].loss, false, new_distance, tile.direction+diff)
                else
                    grid[neighbor[2].location] = Tile(neighbor[2].location, neighbor[2].loss, false, new_distance, diff)
                end
                push!(new_neighbors, grid[neighbor[2].location])
            end
        # end
    end
    return new_neighbors
end

function get_new_neighbors(current_tiles::Vector{Tile}, grid::Dict{Vector{Int},Tile})
    new_neighbors = Vector{Tile}()
    for tile in current_tiles
        index = findall(x -> check_neighbors(tile, x[2]) && x[2].visited == false, collect(grid))
        for i in index
            if collect(grid)[i][2] ∉ new_neighbors
                push!(new_neighbors, collect(grid)[i][2])
            end
        end
    end
    return new_neighbors
end

function propagate_grid(grid::Dict{Vector{Int},Tile}, initial_location::Tile, destination::Tile)
    local_grid = copy(grid)
    local_grid[initial_location.location] = Tile(initial_location.location, initial_location.loss, true, initial_location.loss, [0, 0])
    current_tile = Vector{Tile}([local_grid[initial_location.location]])
    while local_grid[destination.location].visited == false
        next_neighbors = Vector{Tile}()
        for tile in current_tile
            push!(next_neighbors, update_neighbors!(tile, local_grid)...)
            local_grid[tile.location] = Tile(tile.location, tile.loss, true, tile.distance, tile.direction)
        end
        current_tile = next_neighbors
    end
    return local_grid
end

function print_grid(grid::Dict{Vector{Int},Tile})
    grid_x = [1, maximum([key[1] for key in keys(grid)])-1]
    grid_y = [1, maximum([key[2] for key in keys(grid)])-1]
    for y in grid_y[1]:grid_y[2]
        for x in grid_x[1]:grid_x[2]
            print(zfill(string(grid[[x, y]].distance), 4))
        end
        print('\n')
    end
end    

grid = parse_data(data)
grid = propagate_grid(grid, grid[[1, 1]], grid[[13, 13]])
print_grid(grid)

# Part 1 attempt with priority queue

RIGHT, DOWN, LEFT, UP = [1, 0], [0, 1], [-1, 0], [0, -1]
DIRECTIONS = Dict(RIGHT => 1, DOWN => 2, LEFT => 3, UP => 4)
TURNS = Dict(RIGHT => [UP, DOWN], DOWN => [RIGHT, LEFT], LEFT => [DOWN, UP], UP => [LEFT, RIGHT])

struct Path
    heat::Int
    location::Vector{Int}
    direction::Vector{Int}
end

function drive(grid::Dict{Vector{Int},Tile}, start::Vector{Int})
    grid_x = [1, maximum([key[1] for key in keys(grid)])]
    grid_y = [1, maximum([key[2] for key in keys(grid)])]
    distance = Dict{Vector{Int},Vector{Number}}()
    distance[start] = [0, 0, 0, 0] # Order: Right, Down, Left, Up
    
    pq = PriorityQueue()
    pq[Path(0, start, RIGHT)] = 0
    pq[Path(0, start, DOWN)] = 0

    while length(pq) > 0
        path = dequeue!(pq)

        if path.heat > distance[path.location][DIRECTIONS[path.direction]]
            continue
        end

        x, y = path.location

        for step in 1:3
            x += path.direction[1]
            y += path.direction[2]

            # Check if we are out of bounds
            if x < grid_x[1] || x > grid_x[2] || y < grid_y[1] || y > grid_y[2]
                break
            end

            heat = path.heat + grid[[x, y]].loss

            for new_dir in TURNS[path.direction]
                if haskey(distance, [x, y]) == false
                    distance[[x, y]] = [Inf, Inf, Inf, Inf]
                    distance[[x, y]][DIRECTIONS[new_dir]] = heat
                    pq[Path(heat, [x, y], new_dir)] = length(pq)
                elseif heat < distance[[x, y]][DIRECTIONS[new_dir]]
                    distance[[x, y]][DIRECTIONS[new_dir]] = heat
                    pq[Path(heat, [x, y], new_dir)] = length(pq)
                end
            end
        end
    end

    return distance
end

grid = parse_data(data)
distance = drive(grid, [1, 1])