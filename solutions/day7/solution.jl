data = readlines("./solutions/day7/input.txt")
# data = readlines("./solutions/day7/test_input.txt")

ordering = Dict("A" => 13, "K" => 12, "Q" => 11, "J" => 10, "T" => 9, "9" => 8, "8" => 7, "7" => 6, "6" => 5, "5" => 4, "4" => 3, "3" => 2, "2" => 1)

struct entry
    hands::Vector{Int}
    bid::Int
    type::Int
end

function get_type(hands::Vector{Int})
    count = Dict()
    for hand in hands
        if haskey(count, hand)
            count[hand] += 1
        else
            count[hand] = 1
        end
    end
    if length(count) == 1
        return 7
    elseif length(count) == 2 && maximum(values(count)) == 4
        return 6
    elseif length(count) == 2 && maximum(values(count)) == 3
        return 5
    elseif length(count) == 3 && maximum(values(count)) == 3
        return 4
    elseif length(count) == 3 && maximum(values(count)) == 2
        return 3
    elseif length(count) == 4
        return 2
    else
        return 1
    end
end

function isless(entry1::entry, entry2::entry)
    if entry1.type < entry2.type
        return true
    elseif entry1.type == entry2.type
        for i in 1:length(entry1.hands)
            if entry1.hands[i] < entry2.hands[i]
                return true
            elseif entry1.hands[i] > entry2.hands[i]
                return false
            else
                continue
            end
        end
    else
        return false
    end
end

Base.isless(a::entry, b::entry) = isless(a, b)

function parse_line(line::String)
    hands, bids = split(line, " ")
    hands = map(x->ordering[string(x)], collect(hands))
    bid = parse(Int, bids)
    return entry(hands, bid, get_type(hands))
end

stack = parse_line.(data)

ans_part1 = sum(map(x->x.bid, sort(stack)).*collect(1:length(stack)))

# Part 2

ordering_part2 = Dict("A" => 13, "K" => 12, "Q" => 11, "T" => 10, "9" => 9, "8" => 8, "7" => 7, "6" => 6, "5" => 5, "4" => 4, "3" => 3, "2" => 2, "J" => 1)

function get_type_part2(hands::Vector{Int})
    count = Dict()
    for hand in hands
        if haskey(count, hand)
            count[hand] += 1
        else
            count[hand] = 1
        end
    end
    if haskey(count, 1) && length(count) != 1
        joker_count = count[1]
        pop!(count, 1)
        max_key = collect(keys(count))[argmax(collect(values(count)))]
        count[max_key] += joker_count
    end
    if length(count) == 1
        return 7
    elseif length(count) == 2 && maximum(values(count)) == 4
        return 6
    elseif length(count) == 2 && maximum(values(count)) == 3
        return 5
    elseif length(count) == 3 && maximum(values(count)) == 3
        return 4
    elseif length(count) == 3 && maximum(values(count)) == 2
        return 3
    elseif length(count) == 4
        return 2
    else
        return 1
    end
end

function parse_line_part2(line::String)
    hands, bids = split(line, " ")
    hands = map(x->ordering_part2[string(x)], collect(hands))
    bid = parse(Int, bids)
    return entry(hands, bid, get_type_part2(hands))
end

stack_part2 = parse_line_part2.(data)

ans_part2 = sum(map(x->x.bid, sort(stack_part2)).*collect(1:length(stack_part2)))