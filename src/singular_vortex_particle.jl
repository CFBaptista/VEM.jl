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

"""
    compute_velocity(circulation, source, target)

Compute the velocity induced at `target` by a 2D singular irrotational vortex located at `source`.

A counter-clockwise `circulation` is considered positive.

See also [`compute_velocity_gradient`](@ref), [`compute_vorticity`](@ref), [`compute_vorticity_gradient`](@ref).

# Examples
```
julia> circulation = 1.0
1.0

julia> source = [0.0, 0.0]
2-element Vector{Float64}:
 0.0
 0.0

julia> target = [1.0, 0.0]
2-element Vector{Float64}:
 1.0
 0.0

julia> compute_velocity(circulation, source, target)
2-element Vector{Float64}:
 -0.0
  0.15915494309189535
```
"""
function compute_velocity(circulation, source, target)
    r = target - source
    v = cross_2d(circulation, r) / (dot(r, r) * pi * 2)
    return v
end

"""
    compute_velocity_gradient(circulation, source, target)

Compute the velocity gradient induced at `target` by a 2D singular irrotational vortex located at `source`.

A counter-clockwise `circulation` is considered positive.

See also [`compute_velocity`](@ref), [`compute_vorticity`](@ref), [`compute_vorticity_gradient`](@ref).

# Examples
```
julia> circulation = 1.0
1.0

julia> source = [0.0, 0.0]
2-element Vector{Float64}:
 0.0
 0.0

julia> target = [1.0, 0.0]
2-element Vector{Float64}:
 1.0
 0.0

julia> compute_velocity_gradient(circulation, source, target)
2×2 Matrix{Float64}:
  0.0       -0.159155
 -0.159155  -0.0
```
"""
function compute_velocity_gradient(circulation, source, target)
    r = target - source
    rx, ry = r
    return circulation / (dot(r, r)^2 * pi * 2) * [rx*ry -rx^2+ry^2; -rx^2+ry^2 -rx*ry]
end

"""
    compute_vorticity(circulation, source, target)

Compute the vorticity induced at `target` by a 2D singular irrotational vortex located at `source`.

A counter-clockwise `circulation` is considered positive.

See also [`compute_velocity`](@ref), [`compute_velocity_gradient`](@ref), [`compute_vorticity_gradient`](@ref).

# Examples
```
julia> circulation = 1.0
1.0

julia> source = [0.0, 0.0]
2-element Vector{Float64}:
 0.0
 0.0

julia> target = [1.0, 0.0]
2-element Vector{Float64}:
 1.0
 0.0

julia> compute_vorticity(circulation, source, target)
0.0
```
"""
function compute_vorticity(circulation, source, target)
    r = target - source
    return zero(circulation) / dot(r, r)
end

"""
    compute_vorticity_gradient(circulation, source, target)

Compute the vorticity gradient induced at `target` by a 2D singular irrotational vortex located at `source`.

A counter-clockwise `circulation` is considered positive.

See also [`compute_velocity`](@ref), [`compute_velocity_gradient`](@ref), [`compute_vorticity`](@ref).

# Examples
```
julia> circulation = 1.0
1.0

julia> source = [0.0, 0.0]
2-element Vector{Float64}:
 0.0
 0.0

julia> target = [1.0, 0.0]
2-element Vector{Float64}:
 1.0
 0.0

julia> compute_vorticity_gradient(circulation, source, target)
2×2 Matrix{Float64}:
 0.0  0.0
 0.0  0.0
```
"""
function compute_vorticity_gradient(circulation, source, target)
    r = target - source
    return fill(zero(circulation), (2, 2)) / dot(r, r)
end
