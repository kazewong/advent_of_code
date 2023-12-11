data = readlines("./solutions/day11/input.txt")
# data = readlines("./solutions/day11/test_input.txt")

function data_to_map(data::Vector{String})
    output = Matrix{Char}(undef, length(data), length(data[1]))
    for (i, line) in enumerate(data)
        output[i,:] = collect(line)
    end
    return output
end

function copy_row(maps::Matrix{Char}, row::Int)
    return vcat(maps[1:row-1,:], maps[row:row,:], maps[row:end,:])
end

function copy_col(maps::Matrix{Char}, col::Int)
    return hcat(maps[:,1:col-1], maps[:,col:col], maps[:,col:end])
end

function expand_universe(maps::Matrix{Char})
    empty_row_index = Vector{Int}()
    empty_col_index = Vector{Int}()
    for (i, row) in enumerate(eachrow(maps))
        if all(maps[i,:] .== '.')
            push!(empty_row_index, i)
        end
    end
    for (i, col) in enumerate(eachcol(maps))
        if all(maps[:,i] .== '.')
            push!(empty_col_index, i)
        end
    end
    new_map = copy(maps)
    for (i, row) in enumerate(empty_row_index)
        new_map = copy_row(new_map, row+i-1)
    end
    for (i, col) in enumerate(empty_col_index)
        new_map = copy_col(new_map, col+i-1)
    end
    return new_map, empty_row_index, empty_col_index
end

maps = data_to_map(data)
new_maps, empty_row_index, empty_col_index = expand_universe(maps)

galaxy_location = findall(x->x=='#', maps)
galaxy_location_padded = findall(x->x=='#', new_maps)

# Part 1

function manhattan_distance(a::CartesianIndex{2}, b::CartesianIndex{2})
    return abs(a[1]-b[1]) + abs(a[2]-b[2])
end

function compute_distance(location::Vector{CartesianIndex{2}})
    distance_matrix = zeros(Int, length(location), length(location))
    for i in eachindex(location)
        for j in eachindex(location)
            if i <= j
                distance_matrix[i,j] = manhattan_distance(location[i], location[j])
            end
        end
    end
    return distance_matrix
end

part1_ans = sum(compute_distance(galaxy_location_padded))

# Part 2

function weighted_manhattan_distance(a::CartesianIndex{2}, b::CartesianIndex{2}, empty_row_index::Vector{Int}, empty_col_index::Vector{Int}, weight::Int)
    n_rows = abs(a[1]-b[1])
    n_cols = abs(a[2]-b[2])
    row_range = sort([a[1], b[1]])
    col_range = sort([a[2], b[2]])
    n_special_rows = sum(map(x->x<=row_range[2] && x>=row_range[1], empty_row_index)) 
    n_special_cols = sum(map(x->x<=col_range[2] && x>=col_range[1], empty_col_index))
    return (n_rows) + (n_cols) + (n_special_rows + n_special_cols)* (weight-1)
end

function compute_weighted_distance(location::Vector{CartesianIndex{2}}, empty_row_index::Vector{Int}, empty_col_index::Vector{Int}, weight::Int)
    distance_matrix = zeros(Int, length(location), length(location))
    for i in eachindex(location)
        for j in eachindex(location)
            if i <= j
                distance_matrix[i,j] = weighted_manhattan_distance(location[i], location[j], empty_row_index, empty_col_index, weight)
            end
        end
    end
    return distance_matrix
end

part2_ans = sum(compute_weighted_distance(galaxy_location, empty_row_index, empty_col_index, 1000000))