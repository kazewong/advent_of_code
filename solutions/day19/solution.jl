# data = readlines("./solutions/day19/input.txt")
data = readlines("./solutions/day19/test_input.txt")

struct Workflow
    label::String
    conditions::Vector{Function}
end

function parse_workflow(string::String)
    label, conditions = split(string, "{")
    conditions = split(conditions[1:end-1], ",")
    functions = Vector{Function}()
    for condition in conditions
        if ':' ∈ condition
            condition = split(condition, ":")
            if '>' ∈ condition[1]
                part, number = split(condition[1], ">")
                push!(functions, x-> x[part] > parse(Int, number) ? condition[2] : false)
            elseif '<' ∈ condition[1]
                part, number = split(condition[1], "<")
                push!(functions, x-> x[part] < parse(Int, number) ? condition[2] : false)
            end
        else
            push!(functions, x-> condition)
        end
    end
    return Workflow(label, functions)
end

function parse_part(string::String)
    string = string[2:end-1]
    parts = split.(split(string, ","), "=")
    output = Dict{String, Int}()
    for part in parts
        output[part[1]] = parse(Int, part[2])
    end
    return output
end

function parse_data(data::Vector{String})
    workflows = Dict{String, Workflow}()
    parts = Vector{Dict{String, Int}}()
    parsing_workflow = true
    for string in data
        if string == ""
            parsing_workflow = false
        
        elseif parsing_workflow
            workflow = parse_workflow(string)
            workflows[workflow.label] = workflow

        else
            push!(parts, parse_part(string))
        end
    end
    return workflows, parts
end

workflows, parts = parse_data(data)

# Part 1

function evaluate_workflow(part::Dict{String, Int}, workflow::Workflow)
    for condition in workflow.conditions
        if condition(part) != false
            return condition(part)
        end
    end
end

function propagate_part(part::Dict{String, Int}, workflows::Dict{String, Workflow})
    label = "in"
    while label != "A" && label != "R"
        label = evaluate_workflow(part, workflows[label])
    end
    if label == "A"
        return sum(values(part))
    else
        return 0
    end
end

part1_ans = sum(map(x-> propagate_part(x, workflows), parts))

# Part 2

