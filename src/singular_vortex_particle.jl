function cross_2d(number::Number, vector::AbstractVector{<:Number})
    if length(vector) != 2
        throw(
            DimensionMismatch(
                "cross product in 2D between a perpendicular-to-plane vector (represented by a scalar) and an in-plane vector is only defined for an in-plane vector of length 2",
            ),
        )
    end
    return [-number * vector[2], number * vector[1]]
end
cross_2d(vector, number) = -cross_2d(number, vector)

function compute_velocity(circulation, source, target)
    r = target - source
    v = cross_2d(circulation, r) / (dot(r, r) * pi * 2)
    return v
end

function compute_velocity_gradient(circulation, source, target)
    r = target - source
    return circulation / (dot(r, r)^2 * pi * 2) *
           [r[1]*r[2] -r[1]^2+r[2]^2; -r[1]^2+r[2]^2 -r[1]*r[2]]
end
