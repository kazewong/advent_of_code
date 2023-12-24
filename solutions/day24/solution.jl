struct Hail
    position::Vector{Int}
    derivative::Vector{Int}
end

function parse_data(data::Vector{String})
    hails = Hail[]
    for line in data
        position, derivative = split(line, " @ ")
        position = split(position, ", ")
        derivative = split(derivative, ", ")
        position = [parse(Int, x) for x in position]
        derivative = [parse(Int, x) for x in derivative]
        push!(hails, Hail(position, derivative))
    end
    return hails
end

function check_joint(hail1::Hail, hail2::Hail)
    m1 = hail1.derivative[2] / hail1.derivative[1]
    b1 = hail1.position[2] - m1 * hail1.position[1]
    m2 = hail2.derivative[2] / hail2.derivative[1]
    b2 = hail2.position[2] - m2 * hail2.position[1]
    if m1 == m2
        return [Inf, Inf]
    else
        x = (b2 - b1) / (m1 - m2)
        y = m1 * x + b1
        if sign(x - hail1.position[1]) != sign(hail1.derivative[1]) || sign(x - hail2.position[1]) != sign(hail2.derivative[1])
            return [Inf, Inf]
        else
            return [x, y]
        end
    end
end


function count_cross(hails::Vector{Hail}, boundary::Vector{Int})
    counts = 0
    intercept_array = Array{Vector{Number}}(undef, length(hails), length(hails))
    for (index_i, hail_i) in enumerate(hails)
        for (index_j, hail_j) in enumerate(hails)
            if index_i > index_j
                intercept_array[index_i, index_j] = check_joint(hail_i, hail_j)
            if (boundary[1] <= intercept_array[index_i, index_j][1] <= boundary[2]) && (boundary[1] <= intercept_array[index_i, index_j][2] <= boundary[2])
                    counts += 1
                end
            end
        end
    end
    return counts, intercept_array
end

data = readlines("./solutions/day24/input.txt")
# data = readlines("./solutions/day24/test_input.txt")
hails = parse_data(data)
counts, intercept_array = count_cross(hails, [200000000000000,400000000000000])
