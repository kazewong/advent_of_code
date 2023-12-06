data = readlines("./solutions/day6/input.txt")
# data = readlines("./solutions/day6/test_input.txt")

times = parse.(Int, filter(x->x!="", split(data[1], " "))[2:end])
distances = parse.(Int, filter(x->x!="", split(data[2], " "))[2:end])

# Part 1 Damn I think I can do today by hand but I am lazy so I am going brute force it

function distance_travel(button_time::Int, max_time::Int)
    speed = button_time
    return (max_time - button_time) * speed
end

function ways_to_win(max_time::Int, record::Int)
    ways = 0
    for i in 0:max_time
        if distance_travel(i, max_time) > record
            ways += 1
        end
    end
    return ways
end

ans_part1 = prod(ways_to_win.(times, distances))

# Part 2 LOL I am going to brute force it just to see how long it takes

total_time = parse(Int, reduce(*, map(x->string(x), times)))
total_distance = parse(Int, reduce(*, map(x->string(x), distances)))

ans_part2 = prod(ways_to_win.(total_time, total_distance))

# Elegant ways

function quadratic_root(max_time::Int, record::Int)
    a = 1
    b = -max_time
    c = record
    roots = ceil((-b + sqrt(b^2 - 4*a*c)) / (2*a)), ceil((-b - sqrt(b^2 - 4*a*c)) / (2*a))
    return roots[1] - roots[2]
end

ans_part1 = prod(quadratic_root.(times, distances))
ans_part2 = prod(quadratic_root.(total_time, total_distance))