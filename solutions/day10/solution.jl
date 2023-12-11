data = readlines("./solutions/day10/input.txt")
# data = readlines("./solutions/day10/test_input.txt")
# data = readlines("./solutions/day10/test_input_p2.txt")

struct Node
    coords::Tuple{Int,Int}
    type::Int
    connected::Bool
    distance::Int
    up_down::Int
end

# Up is negative unfortunately
types = Dict('|' => 1, '-' => 2, 'L' => 3, 'J' => 4, '7' => 5, 'F' => 6, '.' => 7)#, 'S'=>8)
connection_types = Dict((1, 0) => [2, 4, 5], (-1, 0) => [2, 3, 6], (0, 1) => [1, 3, 4], (0, -1) => [1, 5, 6])
connection_destination = Dict(1 => [(0, 1), (0, -1)], 2 => [(1, 0), (-1, 0)], 3 => [(1, 0), (0, -1)], 4 => [(0, -1), (-1, 0)], 5 => [(0, 1), (-1, 0)], 6 => [(0, 1), (1, 0)], 7 => [(0, 0), (0, 0)])

function check_connected(from_node::Node, to_node::Node)
    # Check if the to_node is connected to the from_node
    diff = (to_node.coords[1] - from_node.coords[1], to_node.coords[2] - from_node.coords[2])
    if (-1 .* diff) in connection_destination[to_node.type]
        return diff
    else
        return (0, 0)
    end
end

function parse_input(data::Vector{String})
    grid = Dict{Tuple{Int,Int},Node}()
    start_coord = (0, 0)
    for (y, line) in enumerate(data)
        for (x, char) in enumerate(line)
            if char == 'S'
                start_coord = (x, y)
                grid[(x, y)] = Node((x, y), -1, true, 0, 0)

            else
                grid[(x, y)] = Node((x, y), types[char], false, -1, -2)
            end
        end
    end
    neighbors = [(1, 0), (-1, 0), (0, 1), (0, -1)]
    new_coord = map(x -> start_coord .+ x, neighbors)
    neightbor_connection = map(x -> all(x .> 0) ? check_connected(grid[start_coord], grid[x]) : 0, new_coord)
    neightbor_connection = filter(x -> x != (0, 0), neightbor_connection)
    start_type = -1
    for (key, value) in connection_destination
        if sort(value) == sort(neightbor_connection)
            start_type = key
        end
    end
    grid[start_coord] = Node(start_coord, start_type, true, 0, sum(connection_destination[start_type][2]))
    return grid, start_coord
end

# Part 1

function flush_pipe!(maps::Dict{Tuple{Int,Int},Node}, start_coord::Tuple{Int,Int})
    step = 0
    flushing = true
    diffs = copy(connection_destination[maps[start_coord].type]) # Be careful about dictionary reference
    next_nodes = map(x -> start_coord .+ x, diffs)
    while flushing
        println("diffs", diffs)
        println("next_nodes", next_nodes)
        if maps[next_nodes[1]].distance != -1
            flushing = false
            break
        end
        step += 1
        for i in eachindex(next_nodes)
            from_diff = -1 .* diffs[i]
            # The following line fucks up big time if you don't copy diffs 
            diffs[i] = filter(x -> x != from_diff, connection_destination[maps[next_nodes[i]].type])[1]
            maps[next_nodes[i]] = Node(next_nodes[i], maps[next_nodes[i]].type, true, step, from_diff[2] - diffs[i][2])
            next_nodes[i] = next_nodes[i] .+ diffs[i]
        end
    end
end

maps, start_coord = parse_input(data)
flush_pipe!(maps, start_coord)
part1_ans = maximum(map(x->x.distance,values(maps)))

# Part 2
# Too tire after training to think of intelligent solution for SDF
# Just iterating line by line by checking intersection

# Even hacking the total size of the diagram to be 140

function check_line(line_number::Int, maps::Dict{Tuple{Int,Int},Node})
    result = 0
    counting = false
    for j in 1:20
        if (maps[(j, line_number)].connected == true) && (maps[(j, line_number)].type != 2)
            counting = !counting
        end
        if (counting == true) && maps[(j,line_number)].type == 7
            result += 1
        end
    end
    return result
end

function print_map(maps::Dict{Tuple{Int,Int},Node}, x_length::Int, y_length::Int)
    total_count = 0
    for i in 1:y_length
        counting = false
        crossing = 0
        for j in 1:x_length
            if (maps[(j, i)].connected == true)
                crossing += maps[(j, i)].up_down
                if abs(crossing) == 2
                    counting = !counting
                    crossing = 0
                end
            end
            if maps[(j,i)].connected == true
                print("\033[32mo")
            else
                # They count all type, not just 7
                if counting == true# && maps[(j,i)].type == 7 Fuck you Kaze, read the instruction man 
                    total_count += 1
                    print("\033[33mx")
                else
                    print("\033[31mx")
                end
            end
        end
        print("          ", crossing,"\n")
    end
    return total_count
end
print_map(maps, 140, 140)

part2_ans = sum(map(x -> check_line(x, maps), collect(1:10)))
