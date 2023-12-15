data = readlines("./solutions/day15/input.txt")
# data = readlines("./solutions/day15/test_input.txt")

strings = split(data[1], ",")

function compute_value(string::AbstractString)
    result = 0
    for character in string
        ascii_value = Int(character)
        result += ascii_value
        result *= 17
        result = result % 256
    end
    return result
end


# Part 1
part1_ans = sum(compute_value.(strings))

# Part 2

struct Lens
    label::String
    value::Int

    function Lens(labels::String, value::String)
        if value == ""
            value = 0
        else
            value = parse(Int, value)
        end
        new(labels, value)
    end
end

function add_to_boxes(strings::AbstractString, boxes::Dict{Int, Vector{Lens}})
    type = '=' in strings ? '=' : '-'
    inputs = split(strings, type)
    lens = Lens(string(inputs[1]), string(inputs[2]))
    value = compute_value(lens.label)
    if type == '='
        if lens.label in map(x->x.label, boxes[value])
            boxes[value][findall(x->x.label==lens.label, boxes[value])[1]] = lens
        else
            push!(boxes[value], lens)
        end
    else
        if lens.label in map(x->x.label, boxes[value])
            deleteat!(boxes[value], findall(x->x.label==lens.label, boxes[value])[1])
        end
    end
end

boxes = Dict{Int, Vector{Lens}}(i=>Vector{Lens}() for i in 0:255)
for string in strings
    add_to_boxes(string, boxes)
end

function focusing_power(boxes::Dict{Int, Vector{Lens}})
    result = 0
    for (key, box) in boxes
        if length(box) > 0
            for (index,lens) in enumerate(box)
                result += index*lens.value*(key+1)
            end
        end
    end
    return result
end

part2_ans = focusing_power(boxes)