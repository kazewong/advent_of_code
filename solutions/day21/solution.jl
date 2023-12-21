
# data = readlines("./solutions/day21/input.txt")
data = readlines("./solutions/day21/test_input.txt")

mutable struct Tile
    type::Bool
    reachable::Bool
end

function parse_data(data::Vector{String})
    tile = Dict{CartesianIndex{2}, Tile}()
    starting_point = CartesianIndex((0, 0))
    for (y, line) in enumerate(data)
        for (x, char) in enumerate(line)
            tile[CartesianIndex((x, y))] = Tile((char == '.')||(char=='S'), false)
            if char == 'S'
                starting_point = CartesianIndex((x, y))
            end
        end
    end
    return tile, starting_point
end

function print_grid(grid::Dict{CartesianIndex{2}, Tile})
    x_max = maximum([i[1] for i in keys(grid)])
    y_max = maximum([i[2] for i in keys(grid)])
    for y in 1:y_max
        for x in 1:x_max
            if grid[CartesianIndex((x, y))].reachable
                print("O")
            else
                print(grid[CartesianIndex((x, y))].type ? "." : "#")
            end
        end
        println()
    end
end



# Part 1

function propagate_grid!(grid::Dict{CartesianIndex{2}, Tile})
    x_max = maximum([i[1] for i in keys(grid)])
    y_max = maximum([i[2] for i in keys(grid)])
    reachable_tiles = filter(x -> x[2].reachable, grid)
    for (index, tile) in reachable_tiles
        for neighbor in CartesianIndex.([(index[1]+1, index[2]), (index[1]-1, index[2]), (index[1], index[2]+1), (index[1], index[2]-1)])
            if (neighbor[1] > 0) && (neighbor[1] <= x_max) && (neighbor[2] > 0) && (neighbor[2] <= y_max) && (grid[neighbor].type)
                grid[neighbor].reachable = true
            end
        end
        tile.reachable = false
    end
end

function propagate_and_count(grid::Dict{CartesianIndex{2}, Tile}, step::Int, starting_point::CartesianIndex{2})
    grid = deepcopy(grid)
    grid[starting_point].reachable = true
    for i in 1:step
        propagate_grid!(grid)
    end
    return count(x -> x[2].reachable, grid), grid
end

grid, starting_point = parse_data(data)
print_grid(grid)
part1_ans, new_grid = propagate_and_count(grid, 64, starting_point)

# Part 2

import Base: +
import Base: ==

function +(grid::Dict{CartesianIndex{2}, Tile}, n::Int)
    grid = deepcopy(grid)
    for i in 1:n
        propagate_grid!(grid)
    end
    return grid
end

function compare_grid(grid1::Dict{CartesianIndex{2}, Tile}, grid2::Dict{CartesianIndex{2}, Tile})
    return all(x -> x[2].reachable == grid2[x[1]].reachable, grid1)
end

function ==(grid1::Dict{CartesianIndex{2}, Tile}, grid2::Dict{CartesianIndex{2}, Tile})
    return compare_grid(grid1, grid2)
end

function fill_cycle_detector(grid::Dict{CartesianIndex{2}, Tile}, starting_point::CartesianIndex{2})
    grid = deepcopy(grid)
    grid[starting_point].reachable = true
    temp_grid = Vector{Dict{CartesianIndex{2}, Tile}}()
    push!(temp_grid, grid)
    loop = true
    while loop
        grid = grid + 1
        if grid in temp_grid
            loop = false
        end
        push!(temp_grid, grid)
    end
    return length(temp_grid)-2
end

function reach_cycle_detector(grid::Dict{CartesianIndex{2}, Tile}, starting_point::CartesianIndex{2}, end_point::CartesianIndex{2})
    grid = deepcopy(grid)
    grid[starting_point].reachable = true
    counter = 0
    loop = true
    while loop
        counter = counter + 1
        grid = grid + 1
        if grid[end_point].reachable
            loop = false
        end
    end
    return counter
end
    

grid, starting_point = parse_data(data)
# grid[starting_point].reachable = true
cycles = cycle_detector(grid, CartesianIndex((11,11)))
reach = map(x->reach_cycle_detector(grid, CartesianIndex((1,1)), CartesianIndex((x,1))), 1:11)
