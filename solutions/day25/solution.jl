mutable struct Node
    label::String
    connected::Vector{String}
end

function parse_data(data::Vector{String})
    nodes = Dict{String, Node}()
    for line in data
        lhs, rhs = split(line, ": ")
        rhs = split(rhs, " ")
        lhs = string(lhs)
        rhs = [string(component) for component in rhs]
        for component in rhs
            if component ∈ keys(nodes)
                push!(nodes[component].connected, lhs)
            else
                nodes[component] = Node(component, [lhs])
            end
        end
        if lhs ∉ keys(nodes)
            nodes[lhs] = Node(lhs, rhs)
        end
    end
    return nodes
end

function node_distance(node1::Node, node2::Node)
    tested_nodes = [node1.label]
    testing_nodes = [node1.label]
    found_node = false
    counter = 0
    while !found_node
        counter += 1
        tested_nodes = unique(filter(x->x ∉ tested_nodes, reduce(vcat, map(x->nodes[x].connected, testing_nodes))))
        if node2.label ∈ tested_nodes
            found_node = true
        else
            testing_nodes = tested_nodes
        end

    end
    return counter
end


data = readlines("./solutions/day25/input.txt")
# data = readlines("./solutions/day25/test_input.txt")

nodes = parse_data(data)

node_distance(nodes["pzl"], nodes["rsh"])