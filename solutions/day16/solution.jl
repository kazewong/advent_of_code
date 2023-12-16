# data = readlines("./solutions/day16/input.txt")
data = readlines("./solutions/day16/test_input.txt")

tile_type = Dict{Char,Int}('.' => 0, '/' => 1, '\\' => 2, '-' => 3, '|' => 4)

struct tile
    energized::Bool
    type::Int
end

struct ray
    location_history::Vector{Vector{Int}}
    direction::Vector{Int}
end

function parse_data(data::Vector{String})
    output = Dict{Vector{Int},tile}()
    for (index, line) in enumerate(data)
        for (index2, char) in enumerate(line)
            output[[index2, index]] = tile(false, tile_type[char])
        end
    end
    return output
end

grid = parse_data(data)

inital_ray = ray([[1, 1]], [1, 0])
# Part 1

function propagate_ray!(input_ray::ray, grid::Dict{Vector{Int},tile})
    grid_x = [minimum([key[1] for key in keys(grid)]), maximum([key[1] for key in keys(grid)])]
    grid_y = [minimum([key[2] for key in keys(grid)]), maximum([key[2] for key in keys(grid)])]
    ray_location = input_ray.location_history[end]
    grid[ray_location] = tile(true, grid[ray_location].type)
    ray_direction = input_ray.direction
    new_ray_location = ray_location + ray_direction
    if new_ray_location[1] < grid_x[1] || new_ray_location[1] > grid_x[2] || new_ray_location[2] < grid_y[1] || new_ray_location[2] > grid_y[2]
        return
    end
    while new_ray_location ∉ input_ray.location_history
        push!(input_ray.location_history, new_ray_location)
        grid[new_ray_location] = tile(true, grid[new_ray_location].type)
        if grid[new_ray_location].type == 1
            input_ray = ray(input_ray.location_history, [-ray_direction[2], -ray_direction[1]])
        elseif grid[new_ray_location].type == 2
            input_ray = ray(input_ray.location_history, [ray_direction[2], ray_direction[1]])
        elseif grid[new_ray_location].type == 3
            if ray_direction[1] == 0
                input_ray = ray(input_ray.location_history, [ray_direction[2], 0])
                split_ray = ray([ray_location], [-ray_direction[2], 0])
                propagate_ray!(split_ray, grid)
            end
        elseif grid[new_ray_location].type == 4
            if ray_direction[2] == 0
                input_ray = ray(input_ray.location_history, [0, ray_direction[1]])
                split_ray = ray([ray_location], [0, -ray_direction[1]])
                propagate_ray!(split_ray, grid)
            end
        end
        ray_location = input_ray.location_history[end]
        ray_direction = input_ray.direction
        new_ray_location = ray_location + ray_direction
        if new_ray_location[1] < grid_x[1] || new_ray_location[1] > grid_x[2] || new_ray_location[2] < grid_y[1] || new_ray_location[2] > grid_y[2]
            break
        end
    end
end

propagate_ray!(inital_ray, grid)