data = readlines("./solutions/day22/input.txt")
# data = readlines("./solutions/day22/test_input.txt")

# I checked there are no high z to low z bricks or 3D bricks

mutable struct Brick
    index::Int
    start_point::CartesianIndex{3}
    end_point::CartesianIndex{3}
    support::Vector{Int}
    supported_by::Vector{Int}
end

function parse_data(data::Vector{String})
    bricks = Vector{Brick}()
    push!(bricks, Brick(1, CartesianIndex((0, 0, 0)), CartesianIndex((10000, 10000, 0)), [], []))
    for (index,line) in enumerate(data)
        start_point, end_point = split(line, "~")
        start_point = CartesianIndex(Tuple(parse.(Int, split(start_point, ","))))
        end_point = CartesianIndex(Tuple(parse.(Int, split(end_point, ","))))
        push!(bricks, Brick(index+1, start_point, end_point, [], []))
    end
    return bricks
end

# Part 1 

function ranges_overlap(range1::AbstractRange, range2::AbstractRange)
    return first(range1) <= last(range2) && first(range2) <= last(range1)
end

function check_support(brick1::Brick, brick2::Brick)
    if brick1.end_point[3] + 1 != brick2.start_point[3]
        return false
    end
    if ranges_overlap(brick1.start_point[1]:brick1.end_point[1], brick2.start_point[1]:brick2.end_point[1]) && ranges_overlap(brick1.start_point[2]:brick1.end_point[2], brick2.start_point[2]:brick2.end_point[2])
        return true
    else
        return false
    end
end

function collapse_bricks(bricks::Vector{Brick})
    sort_bricks = bricks[sortperm(bricks, by=x->x.start_point[3])]
    for (index, brick) in enumerate(sort_bricks[2:end])
        supported = any(map(x->check_support(x,brick), sort_bricks[1:index]))
        if !supported
            # println("Brick $(index) is not supported")
            for (index2, brick2) in enumerate(sort_bricks[index:-1:1])
                start_point = CartesianIndex((brick.start_point[1], brick.start_point[2], minimum([brick.start_point[3], brick2.end_point[3]+1])))
                end_point = CartesianIndex((brick.end_point[1], brick.end_point[2], brick.end_point[3]-brick.start_point[3]+minimum([brick.start_point[3], brick2.end_point[3]+1])))
                sort_bricks[index+1] = Brick(sort_bricks[index+1].index, start_point, end_point, [], [])
                if any(map(x->check_support(x,sort_bricks[index+1]), sort_bricks))
                    break
                end
            end
        end
        sort_bricks = sort_bricks[sortperm(sort_bricks, by=x->x.start_point[3])]
    end
    return sort_bricks
end

function check_brick(brick::Brick, bricks::Vector{Brick})
    top_z = brick.end_point[3] + 1
    valid_bricks = filter(x -> top_z ∈ x.start_point[3]:x.end_point[3], bricks)
    return valid_bricks
end

function support_structure(bricks::Vector{Brick})
    new_bricks = deepcopy(bricks)
    for brick in new_bricks
        target_indices = getfield.(filter(x->check_support(brick, x), new_bricks), :index)
        brick.support = target_indices
        for target_index in target_indices
            push!(filter(x->x.index==target_index,new_bricks)[1].supported_by, brick.index)
        end
    end
    return new_bricks
end

function check_disintegrate(index::Int, bricks::Vector{Brick})
    for brick_index in filter(x->x.index==index,bricks)[1].support
        brick = filter(x->x.index==brick_index, bricks)[1]
        if length(brick.supported_by) == 1
            return false
        end
    end
    return true
end

bricks = parse_data(data)
collapsed_bricks = collapse_bricks(bricks)
collapsed_bricks = support_structure(collapsed_bricks)
part1_ans = sum(map(x->check_disintegrate(x, collapsed_bricks), 1:length(collapsed_bricks)))-1