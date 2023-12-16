data = readlines("./solutions/day16/input.txt")
# data = readlines("./solutions/day16/test_input.txt")

tile_type = Dict{Char,Int}('.' => 0, '/' => 1, '\\' => 2, '-' => 3, '|' => 4)

struct tile
    energized::Bool
    type::Int
end

struct ray
    location::Vector{Int}
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

function print_grid(grid::Dict{Vector{Int},tile})
    grid_x = [1, maximum([key[1] for key in keys(grid)])-1]
    grid_y = [1, maximum([key[2] for key in keys(grid)])-1]
    for y in grid_y[1]:grid_y[2]
        for x in grid_x[1]:grid_x[2]
            if grid[[x, y]].energized
                print('#')
            else
                print('.')
            end
        end
        print('\n')
    end
end

# Part 1

data_length = length(data)
line_length = length(data[1])

function propagate_ray(input_ray::ray, grid::Dict{Vector{Int},tile}, history::Vector{Vector{Int}}=Vector{Vector{Int}}(), size::Tuple{Int,Int}=(line_length, data_length))
    local_grid = copy(grid)
    grid_x = [1, size[1]]
    grid_y = [1, size[2]]
    ray_location = input_ray.location
    ray_direction = input_ray.direction
    local_grid[ray_location] = tile(true, local_grid[ray_location].type)
    while [ray_location...,ray_direction...] ∉ history
        push!(history, [ray_location..., ray_direction...])
        ray_location = ray_location + ray_direction
        if ray_location[1] < grid_x[1] || ray_location[1] > grid_x[2] || ray_location[2] < grid_y[1] || ray_location[2] > grid_y[2]
            break
        end
        local_grid[ray_location] = tile(true, local_grid[ray_location].type)
        if local_grid[ray_location].type == 1
            ray_direction = [-ray_direction[2], -ray_direction[1]]
        elseif local_grid[ray_location].type == 2
            ray_direction = [ray_direction[2], ray_direction[1]]
        elseif local_grid[ray_location].type == 3
            if ray_direction[1] == 0
                split_ray = ray(ray_location, [-ray_direction[2], 0])
                ray_direction = [ray_direction[2], 0]
                local_grid = propagate_ray(split_ray, local_grid, history)
            end
        elseif local_grid[ray_location].type == 4
            if ray_direction[2] == 0
                split_ray = ray(ray_location, [0, -ray_direction[1]])
                ray_direction = [0, ray_direction[1]]
                local_grid = propagate_ray(split_ray, local_grid, history)
            end
        end
    end
    return local_grid
end

grid = parse_data(data)
grid[[0, 1]] = tile(false, 0)
inital_ray = ray([0, 1], [1, 0])
new_grid = propagate_ray(inital_ray, grid)
print_grid(new_grid)

part1_ans = count(tile -> tile.energized, values(new_grid)) - 1

# Part 2

function test_entrace(location::Vector{Int}, direction::Vector{Int}, grid::Dict{Vector{Int},tile})
    local_grid = copy(grid)
    local_grid[location] = tile(true, 0)
    inital_ray = ray(location, direction)
    new_grid = propagate_ray(inital_ray, local_grid)
    return count(tile -> tile.energized, values(new_grid)) - 1
end

grid = parse_data(data)
max_count = -1
for i in 1:length(data)
    count = test_entrace([0, i], [1, 0], grid)
    if count > max_count
        max_count = count
        println(max_count)
    end
    count = test_entrace([11, i], [-1, 0], grid)
    if count > max_count
        max_count = count
        println(max_count)
    end
end

for i in 1:length(data[1])
    count = test_entrace([i, 0], [0, 1], grid)
    if count > max_count
        max_count = count
        println(max_count)
    end
    count = test_entrace([i, 111], [0, -1], grid)
    if count > max_count
        max_count = count
        println(max_count)
    end
end