data = readlines("./solutions/day4/input.txt")
# data = readlines("./solutions/day4/test_input.txt")

struct Card
    number::Int
    winning_number::Vector{Int}
    choice_number::Vector{Int}
end

function parse_card(input::String)
    card, numbers = split(input, ":")
    card_number = parse(Int, last(split(card, " ")))
    winning_number, choice_number = split(numbers, "|")
    winning_number = filter(x->x!="",split(winning_number, " "))
    choice_number = filter(x->x!="",split(choice_number, " "))
    return Card(card_number, parse.(Int, winning_number), parse.(Int, choice_number))
end

cards = parse_card.(data)

# Part1

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

ans_part1 = sum(check_card.(cards))

# Part2

function number_of_wins(card::Card)
    checks = map(x -> x ∈ card.winning_number, card.choice_number)
    return sum(checks)
end

function check_card_copies(card::Card, win_table::Vector{Int})
    number_of_card_gen = 1
    for i in (1:win_table[card.number])
        number_of_card_gen += check_card_copies(cards[card.number+i], win_table)
    end
    return number_of_card_gen
end

win_table = number_of_wins.(cards)
ans_part2 = sum(map(x -> check_card_copies(x, win_table), cards))