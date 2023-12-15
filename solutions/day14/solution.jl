# data = readlines("./solutions/day14/input.txt")
data = readlines("./solutions/day14/test_input.txt")

input_dict = Dict{Char, Int}('#' => 0, 'O' => 1, '.' => 2)

function parse_data(data::Vector{String})
    output = Matrix{Int}(undef, length(data), length(data[1]))
    for (index, line) in enumerate(data)
        output[index, :] = map(x->input_dict[x], collect(line))
    end

    return vcat(zeros(Int, 1, length(data[1])), output, zeros(Int, 1, length(data[1])))
end

pattern = parse_data(data)

# Part 1

function find_load_line(line::AbstractVector)
    line_length = length(line)
    load = 0
    pound_location = line_length + 1 .- (findall(x->x==0, line)) 
    rock_location = line_length +1 .- (findall(x->x==1, line))
    for index in 1:length(pound_location)-1
        n_rock = length(findall(x->(x<pound_location[index]) && (x>pound_location[index+1]), rock_location))
        for i in 0:n_rock-1
            load += pound_location[index] - 2 - i
        end
    end
    return load
end

part1_ans = sum(map(x->find_load_line(x), collect(eachcol(pattern))))

# Part 2 Let's go hardcore on this one

struct entry
    index::Int
    location::Vector{Int}
    type::Int
end

function isless(entry1::entry, entry2::entry, dir_x::Int)
    if entry1.type != entry2.type
        return entry1.type < entry2.type
    else
        return entry1.location[dir_x] < entry2.location[dir_x]
    end
end

function parse_data_part2(data::Vector{String})
    index = 0
    block_length = length(data)
    output = Vector{entry}()
    for i in 1:length(data[1])+2
        push!(output, entry(index, [i, 1], 0))
        push!(output, entry(index+1, [i, length(data[1])+2], 0))
        index += 2
    end
    for i in 2:block_length+1
        push!(output, entry(index,[1, i], 0))
        push!(output, entry(index+1,[length(data)+2, i], 0))
        index += 2
    end
    for (i, line) in enumerate(data)
        for (j,element) in enumerate(line)
            push!(output, entry(index,[j+1, i+1], input_dict[element]))
            index += 1
        end
    end
    return output
end

pattern = parse_data_part2(data)

function roll_line(line::AbstractVector, dir_x::Int, reverse::Bool=false)
    output = deepcopy(line)
    pound_location = sort(map(x->x.location,line[(findall(x->x.type==0, line))]))
    for index in 1:length(pound_location)-1
        entries = output[findall(x->(x.location[dir_x]>pound_location[index][dir_x]) && (x.location[dir_x]<pound_location[index+1][dir_x]), line)]
        new_index = sortperm(entries, lt=(x,y)->isless(x,y,dir_x), rev=reverse)
        for (i, ind) in enumerate(new_index)
            entries[ind].location[dir_x] = pound_location[index][dir_x] + i
        end
    end
    return output
end

function roll_pattern(pattern::Vector{entry}, dir_x::Int, reverse::Bool=false)
    output = deepcopy(pattern)
    for i in 2:maximum(map(x->x.location[dir_x], output))-1
        line = filter(x->x.location[2-dir_x+1]==i, output)
        line = roll_line(line, dir_x, reverse)
        output[findall(x->x.index in map(y->y.index, line), output)] = line
    end
    return output
end

function shake_pattern(pattern::Vector{entry})
    output = deepcopy(pattern)
    output = roll_pattern(output, 2)
    output = roll_pattern(output, 1)
    output = roll_pattern(output, 2, true)
    output = roll_pattern(output, 1, true)
    return output
end

function print_pattern(pattern::Vector{entry})
    print_dict = Dict{Int, Char}(0 => '#', 1 => 'O', 2 => '.')
    for i in 1:maximum(map(x->x.location[2], pattern))
        line = filter(x->x.location[2]==i, pattern)
        index = sortperm(map(x->x.location, line))
        line = line[index]
        type = map(x->print_dict[x.type], line)
        println(type)
    end
end