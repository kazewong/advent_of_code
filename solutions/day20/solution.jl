# data = readlines("./solutions/day20/input.txt")
data = readlines("./solutions/day20/test_input.txt")

abstract type Modules end

mutable struct Broadcaster <: Modules
    label::String
    output_label::Vector{String}
end

mutable struct FilpFlop <: Modules
    label::String
    state::Bool
    output_label::Vector{String}
end

mutable struct Conjunction <: Modules
    label::String
    state::Dict{String,Bool}
    output_label::Vector{String}
end

function parse_data(data::Vector{String})
    modules = Dict{String, Modules}()
    for line in data
        label, outputs = split(line, " -> ")
        if '%' in label
            modules[label[2:end]] = FilpFlop(label[2:end], false, split(outputs, ", "))
        elseif '&' in label
            modules[label[2:end]] = Conjunction(label[2:end], Dict{String,Bool}(), split(outputs, ", "))
        else
            modules[label] = Broadcaster(label, split(outputs, ", "))
        end
    end
    for (label, local_module) in modules
        if typeof(local_module) == Conjunction
            inputs = Dict{String,Bool}()
            for y in values(modules)
                if any(map(x->occursin(label, x), y.output_label))
                    inputs[y.label] = false
                end
            end
            modules[label] = Conjunction(label, inputs, local_module.output_label)
        end
    end

    return modules
end


# Part 1

high_low_dict = Dict{Bool, String}(false=>"low", true=>"high")

function receive_pulse!(input_label::String, pulse::Bool, local_module::Broadcaster, modules::Dict{String, Modules}, counter::Dict{Bool, Int})
    for output in local_module.output_label
        counter[false] += 1
        println("$(local_module.label) -low-> $output")
    end
    for output in local_module.output_label
        if output in keys(modules)
            receive_pulse!(local_module.label, false, modules[output], modules, counter)
        end
    end
end

function receive_pulse!(input_label::String, pulse::Bool, local_module::FilpFlop, modules::Dict{String, Modules}, counter::Dict{Bool, Int})
    if !pulse
        local_module.state = !local_module.state
        for output in local_module.output_label
            counter[local_module.state] += 1
            println("$(local_module.label) -$(high_low_dict[local_module.state])-> $output")
        end
        for output in local_module.output_label
            if output in keys(modules)
                receive_pulse!(local_module.label, local_module.state, modules[output], modules, counter)
            end
        end
    end
end

function receive_pulse!(input_label::String, pulse::Bool, local_module::Conjunction, modules::Dict{String, Modules}, counter::Dict{Bool, Int})
    local_module.state[input_label] = pulse
    if all(values(local_module.state))
        for output in local_module.output_label
            counter[false] += 1
            println("$(local_module.label) -low-> $output")
        end
        for output in local_module.output_label
            if output in keys(modules)
                receive_pulse!(local_module.label, false, modules[output], modules, counter)
            end
        end
    else
        for output in local_module.output_label
            counter[true] += 1
            println("$(local_module.label) -high-> $output")
        end
        for output in local_module.output_label
            if output in keys(modules)
                receive_pulse!(local_module.label, true, modules[output], modules, counter)
            end
        end
    end
end


function push_botton(modules::Dict{String, Modules}, counter::Dict{Bool, Int})
    local_modules = deepcopy(modules)
    counter[false] += 1
    println("button -low-> $(local_modules["broadcaster"].label)")
    receive_pulse!("button", false, local_modules["broadcaster"], modules, counter)
    return counter
end

modules = parse_data(data)
counter = Dict{Bool, Int}(false=>0, true=>0)
push_botton(modules, counter)