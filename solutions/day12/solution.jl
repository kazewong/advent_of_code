using Memoize
data = readlines("./solutions/day12/input.txt")
# data = readlines("./solutions/day12/test_input.txt")

function parse_line(line::String)
    record, info = split(line, " ")
    info = parse.(Int, split(info, ","))
    return string(record) * ".", info
end


@memoize function count_arrangement(position::Int, group::Int, record::String, info::Vector{Int})

    # println(position," ",group, " ", length(record), " ", length(info))
    if group > length(info)
        if (position < length(record)) && ('#' ∈ record[position:end])
            # Run out of groups but still have some broken spring left
            # println("+0")
            return 0
        else
            # println("+1")
            return 1
        end
    end

    if position > length(record) - 1
        # Run out of record but still have some groups left
        return 0
    end

    # println(record[position])

    # minimum([length(record),position+info[group]])

    if record[position] == '?'
        if (position + info[group] - 1) >= length(record)
            # This spring cannot be broken since there is no enough space for the group
            return 0
            # This spring is broken and start the group here
        elseif ('.' ∉ record[position:position+info[group]-1]) && (record[position+info[group]] != '#')
            return count_arrangement(position + info[group] + 1, group + 1, record, info) + count_arrangement(position + 1, group, record, info)
        else
            # This spring is operational
            return count_arrangement(position + 1, group, record, info)
        end
    elseif record[position] == '#'
        if (position + info[group] - 1) >= length(record)
            # This spring cannot be broken since there is no enough space for the group
            return 0
        elseif ('.' ∉ record[position:position+info[group]-1]) && (record[position+info[group]] != '#')
            return count_arrangement(position + info[group] + 1, group + 1, record, info)
        else
            return 0
        end
    elseif record[position] == '.'
        return count_arrangement(position + 1, group, record, info)
    end
end

lines = map(parse_line, data)
count_arrangement(1, 1, lines[1][1], lines[1][2])
count_arrangement(1, 1, lines[2][1], lines[2][2])
past1_ans = sum(map(x -> count_arrangement(1, 1, x[1], x[2]), lines))

# Part 2

function expand_record(record::String, info::Vector{Int})
    new_record = ""
    new_info = Vector{Int}()
    for i in 1:4
        new_record *= record
        new_record *= "?"
        push!(new_info, info...)
    end
    new_record *= record
    push!(new_info, info...)
    return new_record, new_info
end

function parse_line_part2(line::String)
    record, info = split(line, " ")
    info = parse.(Int, split(info, ","))
    record, info = expand_record(string(record), info)
    return record * ".", info
end

lines = map(parse_line_part2, data)

part2_ans = sum(map(x -> count_arrangement(1, 1, x[1], x[2]), lines))