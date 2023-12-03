data = readlines("./solutions/day3/input.txt")
# data = readlines("./solutions/day3/test_input.txt")

# Part 1

abstract type entry end

struct symbol <: entry
    string::Char
    left::Int
    top::Int
end

struct part <: entry
    number::Int
    left::Int
    right::Int
    top::Int
end

function trace_right(index::Int, input::String)
    output = ""
    left_index = index
    right_index = index
    while isdigit(input[right_index])
        output *= string(input[right_index])
        if right_index == length(input)
            right_index += 1
            break
        end
        right_index += 1
    end
    return output, left_index, right_index
end


function readPartLine(input::String, line::Int)
    entries = Vector{entry}()
    counter = 1
    while counter <= length(input)
        if isdigit(input[counter])
            number, left, right = trace_right(counter, input)
            push!(entries, part(parse(Int, number), left, right - 1, line))
            counter = right - 1
        elseif input[counter] != '.'
            push!(entries, symbol(input[counter], counter, line))
        end
        counter += 1
    end
    return entries
end

function checkPart(part::part, schematic::Vector{Vector{entry}})
    result = false
    symbolVector = Vector{symbol}()
    symbolVector = vcat(symbolVector, filter(x->x isa symbol, schematic[part.top]))
    if part.top != 1
        symbolVector = vcat(symbolVector, filter(x->x isa symbol, schematic[part.top-1]))
    end
    if part.top != length(schematic)
        symbolVector = vcat(symbolVector, filter(x->x isa symbol, schematic[part.top+1]))
    end
    for symbol in symbolVector
        if symbol.left >= part.left - 1 && symbol.left <= part.right + 1
            result = true
        end
    end
    return result
end

function checkSchematicPart1(schematic::Vector{Vector{entry}})
    rolling_sum = 0
    for index in eachindex(schematic)
        for entry in schematic[index]
            if entry isa part
                println(entry.top," ",entry.number, " ", checkPart(entry, schematic))
                if checkPart(entry, schematic)
                    rolling_sum += entry.number
                end
            end
        end
    end
    return rolling_sum
end

schematic = readPartLine.(data, 1:length(data))
checkPart(schematic[1][1], schematic)
checkSchematicPart1(schematic)

# Part 2

function checkGear(symbol::symbol, schematic::Vector{Vector{entry}})
    partVector = Vector{part}()
    partVector = vcat(partVector, filter(x->x isa part, schematic[symbol.top]))
    if symbol.top != 1
        partVector = vcat(partVector, filter(x->x isa part, schematic[symbol.top-1]))
    end
    if symbol.top != length(schematic)
        partVector = vcat(partVector, filter(x->x isa part, schematic[symbol.top+1]))
    end
    partVector = filter(x -> if (abs(x.left - symbol.left) <= 1) || (abs(x.right - symbol.left) <= 1) return true else false end, partVector)
    if length(partVector) == 2
        return prod(getfield.(partVector, :number))
    else
        return 0
    end
end

function checkSchematicPart2(schematic::Vector{Vector{entry}})
    rolling_sum = 0
    for index in eachindex(schematic)
        for entry in schematic[index]
            if entry isa symbol
                rolling_sum += checkGear(entry, schematic)
            end
        end
    end
    return rolling_sum
end

schematic = readPartLine.(data, 1:length(data))
checkGear(schematic[2][1], schematic)
checkSchematicPart2(schematic)