# data = readlines("./solutions/day10/input.txt")
data = readlines("./solutions/day10/test_input.txt")

struct Node
    coords::Tuple{Int, Int}
    type::Int
    connected::Bool
    distance::Int
end

types = Dict('|'=>1, '-'=>2, 'L'=>3, 'J'=>4, '7'=>5, 'F'=>6, '.'=>7)#, 'S'=>8)
connection_types = Dict((1,0)=>[2,4,5], (-1,0)=>[2,3,6], (0,1)=>[1,3,4], (0,-1)=>[1,5,6])
connection_matrix = Dict(1=>[0 0; 1 1], 2=>[1 1; 0 0], 3=>[1 0; 0 1], 4=>[0 1; 0 1], 5=>[0 1; 1 0], 6=>[1 0; 1 0], 7=>[0 0; 0 0])

function check_connected(diff::Tuple{Int,Int}, node::Node)
    if node.type in connection_types[diff]
        return true
    else
        return false
    end
end

function parse_input(data::Vector{String})
    grid = Dict()
    start_coord = (0, 0)
    for (y, line) in enumerate(data)
        for (x, char) in enumerate(line)
            if char == 'S'
                start_coord = (x, y)
                grid[(x, y)] = Node((x, y), -1, true, 0)

            else
                grid[(x, y)] = Node((x, y), types[char], false, -1)
            end
        end
    end
    neighbors = [(1, 0), (-1, 0), (0, 1), (0, -1)]
    neightbor_connection = map(diff->check_connected(diff, grid[(start_coord[1]+diff[1], start_coord[2]+diff[2])]), neighbors)
    start_type = -1
    connections = transpose(reshape(neightbor_connection, 2, 2))
    for (key, value) in connection_matrix
        if value == connections
            start_type = key
        end
    end
    grid[start_coord] = Node(start_coord, start_type, true, 0)
    return grid, start_coord
end

maps, start_coord = parse_input(data)