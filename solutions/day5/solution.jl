data = readlines("./solutions/day5/input.txt")
# data = readlines("./solutions/day5/test_input.txt")

struct Map
    name::String
    destination_start::Vector{Int}
    source_start::Vector{Int}
    range::Vector{Int}
end

function parse_data(file::Vector{String})
    seeds = parse.(Int, split(file[1]," ")[2:end])

    maps = Vector{Map}()
    reading_map = false
    destination_start = Vector{Int}()
    source_start = Vector{Int}()
    range = Vector{Int}()
    name = ""
    for index in 3:length(file)
        if occursin("map", file[index])
            name = split(file[index]," ")[1]
            reading_map = true
            continue
        end
        if file[index] == "" || index == length(file)
            reading_map = false
            push!(maps, Map(name, destination_start, source_start, range))
            name = ""
            destination_start = Vector{Int}()
            source_start = Vector{Int}()
            range = Vector{Int}()
            continue
        end
        if reading_map == true
            push!(destination_start, parse(Int, split(file[index]," ")[1]))
            push!(source_start, parse(Int, split(file[index]," ")[2]))
            push!(range, parse(Int, split(file[index]," ")[3]))
        end
    end
    return seeds, maps
end

seeds, maps = parse_data(data)

# Part 1

function push_through_map(seed::Int, map::Map)
    destination = seed
    for index in 1:length(map.source_start)
        distance = seed - map.source_start[index]
        if distance >= 0 && distance < map.range[index]
            destination = map.destination_start[index]+distance
        end
    end
    return destination
end

function find_location(seed::Int, maps::Vector{Map})
    result = seed
    for map in maps
        result = push_through_map(result, map)
    end
    return result
end

push_through_map(seeds[1], maps[1])
ans_part1 = minimum(map(x->find_location(x, maps), seeds))

# Part 2

function cut_line(line1::Tuple{Int,Int}, line2::Tuple{Int,Int})
    cutting_points = Vector{Int}([line1[1]])
    if line2[1] > line1[1] && line2[1] < line1[2]
        push!(cutting_points, (line2[1]))
    end
    if line2[2] > line1[1] && line2[2] < line1[2]
        push!(cutting_points, (line2[2]+1))
    end
    push!(cutting_points, line1[2]+1)
    output = Vector{Tuple{Int,Int}}()
    for index in 1:length(cutting_points)-1
        push!(output, (cutting_points[index], cutting_points[index+1]-1))
    end
    return output
end

function push_through_map_reverse(seed::Int, map::Map)
    destination = seed
    for index in 1:length(map.destination_start)
        distance = seed - map.destination_start[index]
        if distance >= 0 && distance < map.range[index]
            destination = map.source_start[index]+distance
        end
    end
    return destination
end

function push_through_map(lines::Vector{Tuple{Int,Int}}, map_local::Map)
    for index in 1:length(map_local.source_start)
        lines = vcat(map(x->cut_line(x, (map_local.source_start[index], map_local.source_start[index]+map_local.range[index]-1)), lines)...)
    end
    for index in eachindex(lines)
        lines[index] = (push_through_map(lines[index][1], map_local), push_through_map(lines[index][2], map_local))
    end
    return lines
end

function find_location_range(seed::Int, range::Int, maps::Vector{Map})
    lines = Vector{Tuple{Int,Int}}([(seed, seed+range-1)])
    for map in maps
        lines = push_through_map(lines, map)
    end
    return lines
end

seed_pair = Vector{Tuple{Int,Int}}()
for i in 1:2:length(seeds)
    push!(seed_pair, (seeds[i], seeds[i+1]))
end

ans_part2 = map(x->find_location_range(x[1], x[2], maps), seed_pair)