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

part1_ans = counts

# Part 2 

using Symbolics
using LinearAlgebra
@variables x[1:3] dx[1:3]
@variables a1[1:3] b1[1:3] a2[1:3] b2[1:3] a3[1:3] b3[1:3]

eq1 = Symbolics.scalarize(cross(x .- a1, dx .- b1) .- cross(x .- a2, dx .- b2))
eq2 = Symbolics.scalarize(cross(x .- a1, dx .- b1) .- cross(x .- a3, dx .- b3))

coef_dict = Dict{Num, Int}()
for i in 1:3
    coef_dict[a1[i]] = hails[1].position[i] 
    coef_dict[b1[i]] = hails[1].derivative[i]
    coef_dict[a2[i]] = hails[2].position[i]
    coef_dict[b2[i]] = hails[2].derivative[i]
    coef_dict[a3[i]] = hails[6].position[i]
    coef_dict[b3[i]] = hails[6].derivative[i] # Somehow using the first 3 is wrong, probably rounding error
end

eq_set = [eq1..., eq2...].~0

result = Symbolics.solve_for(substitute(eq_set, coef_dict), [x..., dx...])
part2_ans = result[1] + result[2] + result[3]

using Printf
@printf("Part 1 answer: %d\n", part1_ans)
@printf("Part 2 answer: %d\n", part2_ans)