using DataStructures

data = readlines("./solutions/day20/input.txt")
# data = readlines("./solutions/day20/test_input.txt")

abstract type Modules end

mutable struct Broadcaster <: Modules
    label::String
    state::Bool
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

struct Message
    input::String
    output::String
    high_low::Bool
    priority::Int
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
            modules[label] = Broadcaster(label, false, split(outputs, ", "))
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

function process_message!(message::Message, local_module::Broadcaster)
    result = Vector{Message}()
    priority = message.priority + 1
    for output in local_module.output_label
        push!(result, Message(local_module.label, output, message.high_low, priority))
    end
    return result
end

function process_message!(message::Message, local_module::FilpFlop)
    result = Vector{Message}()
    priority = message.priority + 1
    if !message.high_low
        local_module.state = !local_module.state
        for output in local_module.output_label
            push!(result, Message(local_module.label, output, local_module.state, priority))
        end
    end
    return result
end

function process_message!(message::Message, local_module::Conjunction)
    result = Vector{Message}()
    priority = message.priority + 1
    local_module.state[message.input] = message.high_low
    if all(values(local_module.state))
        for output in local_module.output_label
            push!(result, Message(local_module.label, output, false, priority))
        end
    else
        for output in local_module.output_label
            push!(result, Message(local_module.label, output, true, priority))
        end
    end
    return result
end

function push_botton(modules::Dict{String, Modules}, counter::Dict{Bool, Int})
    local_modules = deepcopy(modules)
    pq = PriorityQueue{Message, Int}()
    counter[false] += 1
    message = Message("button", local_modules["broadcaster"].label, false, 0)
    pq[message] = message.priority
    while length(pq) > 0
        message = dequeue!(pq)

        # println("$(message.input) -$(high_low_dict[message.high_low])-> $(message.output)")

        if message.output in keys(local_modules)
            new_message = process_message!(message, local_modules[message.output])
            for m in new_message
                println("$(m.input) -$(high_low_dict[m.high_low])-> $(m.output)")
                if m.output in keys(local_modules)
                    enqueue!(pq, m, m.priority)
                end
                if m.high_low
                    counter[true] += 1
                else
                    counter[false] += 1
                end
            end
        end
    end
    return local_modules, counter
end

modules = parse_data(data)
pulse_counter = Dict{Bool, Int}(false=>0, true=>0)
modules, pulse_counter = push_botton(modules, pulse_counter)

# Brute force is fast anyway YOLO
# for i in 1:1000
#     modules, pulse_counter = push_botton(modules, pulse_counter)
# end

cycle_dependenies = ["sx", "jt", "kb", "ks"]

function find_subgraph(label::String, modules::Dict{String, Modules})
    labels = [label]
    modules_list = collect(values(modules))
    subgraph = Dict{String, Modules}()
    output_labels = getfield.(modules_list, :output_label)
    searching = true
    while searching
        for y in labels
            new_labels = modules_list[map(x->y in x, output_labels)]
            if length(new_labels) == 0
                searching = false
            end
            for new_label in new_labels
                if !(new_label.label in labels)
                    push!(labels, new_label.label)
                end
            end
        end
    end
    for label in labels
        subgraph[label] = modules[label]
    end
    return subgraph
end

function cycle_detector(label::String, modules::Dict{String, Modules})
    local_modules = deepcopy(modules)
    sub_modules = find_subgraph(label, local_modules)
    counter = 0
    initial_state = deepcopy(getfield.(values(sub_modules), :state))
    detector = true
    while detector
        counter +=1
        pq = PriorityQueue{Message, Int}()
        message = Message("button", sub_modules["broadcaster"].label, false, 0)
        pq[message] = message.priority
        while length(pq) > 0
            message = dequeue!(pq)
            if message.output in keys(sub_modules)
                new_message = process_message!(message, sub_modules[message.output])
                for m in new_message
                    if m.output in keys(sub_modules)
                        enqueue!(pq, m, m.priority)
                    end                  
                end
            end
        end
        if getfield.(values(sub_modules), :state) == initial_state
            detector = false
        end
    end
    return counter
end

cycles = map(x->cycle_detector(x, modules), cycle_dependenies)
part2_ans = prod(cycles)