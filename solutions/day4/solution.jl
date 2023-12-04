data = readlines("./solutions/day4/input.txt")
# data = readlines("./solutions/day4/test_input.txt")

struct Card
    number::Int
    winning_number::Vector{Int}
    choice_number::Vector{Int}
end

# Part1

function parse_card(input::String)
    card, numbers = split(input, ":")
    card_number = parse(Int, last(split(card, " ")))
    winning_number, choice_number = split(numbers, "|")
    winning_number = filter(x->x!="",split(winning_number, " "))
    choice_number = filter(x->x!="",split(choice_number, " "))
    return Card(card_number, parse.(Int, winning_number), parse.(Int, choice_number))
end

function check_card(card::Card)
    checks = map(x -> x ∈ card.winning_number, card.choice_number)
    number_of_wins = sum(checks)
    if number_of_wins == 0
        score = 0
    else
        score = 2^(number_of_wins-1)
    end
    return score
end

cards = parse_card.(data)
sum(check_card.(cards))