
data = readlines("./solutions/day21/input.txt")
# data = readlines("./solutions/day21/test_input.txt")

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
    x_min = minimum([i[1] for i in keys(grid)])
    y_min = minimum([i[2] for i in keys(grid)])
    for y in y_min:y_max
        for x in x_min:x_max
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
    x_min = minimum([i[1] for i in keys(grid)])
    y_min = minimum([i[2] for i in keys(grid)])
    reachable_tiles = filter(x -> x[2].reachable, grid)
    for (index, tile) in reachable_tiles
        for neighbor in CartesianIndex.([(index[1]+1, index[2]), (index[1]-1, index[2]), (index[1], index[2]+1), (index[1], index[2]-1)])
            if (neighbor[1] >= x_min) && (neighbor[1] <= x_max) && (neighbor[2] >= y_min) && (neighbor[2] <= y_max) && (grid[neighbor].type)
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

# Cycle detection is a red herring!
# function fill_cycle_detector(grid::Dict{CartesianIndex{2}, Tile}, starting_point::CartesianIndex{2})
#     grid = deepcopy(grid)
#     grid[starting_point].reachable = true
#     temp_grid = Vector{Dict{CartesianIndex{2}, Tile}}()
#     push!(temp_grid, grid)
#     loop = true
#     while loop
#         grid = grid + 1
#         if grid in temp_grid
#             loop = false
#         end
#         push!(temp_grid, grid)
#     end
#     return length(temp_grid)-2
# end

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

# repeat the grid
function replicate_grid(grid::Dict{CartesianIndex{2}, Tile}, n::Int)
    new_grid = deepcopy(grid)
    x_max = maximum([i[1] for i in keys(grid)])
    y_max = maximum([i[2] for i in keys(grid)])
    for i in -n:n
        for j in -n:n
            for (index, tile) in grid
                index = CartesianIndex((index[1]+x_max*i, index[2]+y_max*j))
                new_grid[index] = deepcopy(tile)
            end
        end
    end
    return new_grid
end


grid, starting_point = parse_data(data)
big_grid = replicate_grid(grid, 6)
a1, new_grid = propagate_and_count(big_grid, 65, starting_point)
a2, new_grid = propagate_and_count(big_grid, 196, starting_point)
a3, new_grid = propagate_and_count(big_grid, 327, starting_point)

a = (a1 - 2*a2 + a3)/2
b = (-3*a1 + 4*a2 - a3) /2
c = a1
n = 26501365÷131

part2_ans = a*n^2 + b*n + c

using Printf
@printf("Part 1 answer: %d\n", part1_ans)
@printf("Part 2 answer: %d\n", part2_ans)

