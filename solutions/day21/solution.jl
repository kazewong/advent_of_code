
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
    return count(x -> x[2].reachable, grid)
end

grid, starting_point = parse_data(data)
print_grid(grid)
part1_ans = propagate_and_count(grid, 64, starting_point)