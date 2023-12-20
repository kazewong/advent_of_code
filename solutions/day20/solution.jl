# data = readlines("./solutions/day20/input.txt")
data = readlines("./solutions/day20/test_input.txt")

abstract type Modules end

struct Broadcaster <: Modules
    label::String
    output_label::Vector{String}
end

struct FilpFlop <: Modules
    label::String
    state::Bool
    output_label::Vector{String}
end

struct Conjunction <: Modules
    label::String
    state::Vector{Bool}
    output_label::Vector{String}
end

function parse_data(data::Vector{String})
    modules = Dict{String, Modules}()
    for line in data
        label, outputs = split(line, " -> ")
        if '%' in label
            modules[label[2:end]] = FilpFlop(label[2:end], false, split(outputs, ", "))
        elseif '&' in label
            modules[label[2:end]] = Conjunction(label[2:end], [false], split(outputs, ", "))
        else
            modules[label] = Broadcaster(label, split(outputs, ", "))
        end
    end
    for (label, local_module) in modules
        if typeof(local_module) == Conjunction
            inputs = Vector{Bool}()
            for y in values(modules)
                if any(map(x->occursin(label, x), y.output_label))
                    push!(inputs, false)
                end
            end
            modules[label] = Conjunction(label, inputs, local_module.output_label)
        end
    end

    return modules
end

modules = parse_data(data)

# Part 1