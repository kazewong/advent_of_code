# data = readlines("./solutions/day2/input.txt")
data = readlines("./solutions/day2/test_input.txt")

# Part 1

struct Game
    number::Int
    round::Int
    red::Vector{Int}
    green::Vector{Int}
    blue::Vector{Int}
end

function readGameInfo(input::String) 
    number, game = split(input, ':')
    number = parse(Int, split(number, ' ')[2])
    game = split(game, ';')
    round = split.(game, ',')
    red = Vector{Int}()
    green = Vector{Int}()
    blue = Vector{Int}()
    for i in eachindex(round)
        if !occursin("red", game[i])
            push!(red, 0)
        end
        if !occursin("green", game[i])
            push!(green, 0)
        end
        if !occursin("blue", game[i])
            push!(blue, 0)
        end
        for entry in round[i]
            if occursin("red", entry)
                push!(red, parse(Int, split(entry, ' ')[2]))
            elseif occursin("green", entry)
                push!(green, parse(Int, split(entry, ' ')[2]))
            elseif occursin("blue", entry)
                push!(blue, parse(Int, split(entry, ' ')[2]))
            end
        end
    end
    return Game(number, length(round), red, green, blue)
end

games = readGameInfo.(data)

function checkGame(game::Game)
    if any(game.red .> 12) || any(game.green .> 13) || any(game.blue .> 14)
        return false
    else
        return true
    end
end

part1_ans = sum(getfield.(games[checkGame.(games)], :number))

# Part 2

function getPower(game::Game)
    return maximum(game.red) * maximum(game.green) * maximum(game.blue)
end

sum(getPower.(games))