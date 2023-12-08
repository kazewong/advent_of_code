using DataStructures

data = readlines("./solutions/day8/input.txt")
# data = readlines("./solutions/day8/test_input.txt")

instructions = data[1]
nodes = OrderedDict{String, Tuple{String, String}}()

for i in eachindex(data)[3:end]
    current = data[i][1:3]
    nodes[current] = (data[i][8:10], data[i][13:15])
end

# Part 1

function count_step(current::String, nodes::OrderedDict{String, Tuple{String, String}})
    steps = 1
    while current != "ZZZ"
        instruction = instructions[mod1(steps,length(instructions))]
        if instruction == 'L'
            current = nodes[current][1]
        elseif instruction == 'R'
            current = nodes[current][2]
        end
        steps += 1
    end
    return steps - 1
end

ans_part1 = count_step("AAA", nodes)

# Part 2 Brute force will make big complexity, instead, find LCM

function count_step(current::String, nodes::OrderedDict{String, Tuple{String, String}})
    steps = 1
    while current[3] != 'Z'
        instruction = instructions[mod1(steps,length(instructions))]
        if instruction == 'L'
            current = nodes[current][1]
        elseif instruction == 'R'
            current = nodes[current][2]
        end
        steps += 1
    end
    return steps - 1
end

starts = collect(filter(x->x[3]=='A', keys(nodes)))
individual_step = map(x->count_step(x, nodes), starts)

ans_part2 = foldl(lcm, individual_step)