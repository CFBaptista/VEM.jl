"""
    GaussianVortexBlob(circulation::Union{Scalar,StaticArrays.SVector{Dimension,Scalar}}, center::StaticArrays.SVector{Dimension, Scalar}, radius::Scalar) where {Dimension, Scalar}
    GaussianVortexBlob(circulation, center::AbstractVector, radius)
    GaussianVortexBlob(circulation, center::StaticArrays.SVector, radius)
    GaussianVortexBlob(circulation, center::Tuple, radius)

A smooth vortex blob with a Gaussian vorticity distribution.
It is characterized by an amount of circulation it carries, a position and a finite core radius.

# Arguments
- `circulation`: The circulation strength of the vortex blob.
- `center`: The position of the vortex blob.
- `radius`: The core radius of the vortex blob.

# Returns
A `GaussianVortexBlob` instance.
"""
mutable struct GaussianVortexBlob{Dimension,Scalar} <: AbstractVortexBlob{Dimension,Scalar}
    circulation::Union{Scalar,SA.SVector{Dimension,Scalar}}
    center::SA.SVector{Dimension,Scalar}
    radius::Scalar
    function GaussianVortexBlob{Dimension,Scalar}(
        circulation, center, radius
    ) where {Dimension,Scalar}
        if (length(circulation) == 1 && Dimension == 2) ||
            length(circulation) == 3 && Dimension == 3
            return new{Dimension,Scalar}(circulation, center, radius)
        end
        throw(
            ArgumentError(
                "A vortex blob is either 2D or 3D.\n    - In 2D: `circulation` is a scalar and `center` is a 2-vector.\n    - In 3D: `circulation` and `center` are both 3-vectors.",
            ),
        )
    end
end

function GaussianVortexBlob(circulation, center, radius)
    _circulation = if circulation isa Union{AbstractFloat,SA.SVector}
        circulation
    else
        SA.SVector(circulation...)
    end

    _center = center isa SA.SVector ? center : SA.SVector(center...)

    return GaussianVortexBlob{length(_center),eltype(_center)}(_circulation, _center, radius)
end

"""
    induced_velocity(blob::GaussianVortexBlob{2}, target)

Compute the velocity induced at `target` due to a 2D Gaussian vortex blob.

# Arguments
- `blob`: The vortex blob.
- `target`: The target position.

# Returns
The induced velocity at `target`.
"""
function induced_velocity(blob::GaussianVortexBlob{2}, target)
    distance_squared, radius_squared, unscaled_influence, scaler, small_value = induced_velocity_setup_helper(
        blob, target
    )

    mollifier = 1 - exp(-distance_squared / (2 * radius_squared))

    velocity = induced_velocity_output_helper(unscaled_influence, scaler, mollifier, small_value)

    return velocity
end

function induced_velocity_setup_helper(blob::AbstractVortexBlob{2}, target)
    distance, distance_squared, radius_squared = blob_target_distance_setup_helper(blob, target)

    unscaled_influence = planar_cross(blob.circulation, distance)
    scaler = distance_squared * pi * 2
    small_value = eps(eltype(target))

    return distance_squared, radius_squared, unscaled_influence, scaler, small_value
end

function blob_target_distance_setup_helper(blob::AbstractVortexBlob{2}, target)
    distance = target - blob.center
    distance_squared = LA.dot(distance, distance)
    radius_squared = blob.radius^2

    return distance, distance_squared, radius_squared
end

function planar_cross(scalar, vector)
    result = typeof(vector)(-scalar * vector[2], scalar * vector[1])
    return result
end

function induced_velocity_output_helper(unscaled_influence, scaler, mollifier, small_value)
    velocity = unscaled_influence * (mollifier / (scaler + small_value))
    return velocity
end

"""
    induced_vorticity(blob::GaussianVortexBlob{2}, target)

Compute the vorticity induced at `target` due to a 2D Gaussian vortex blob.

# Arguments
- `blob`: The vortex blob.
- `target`: The target position.

# Returns
The induced vorticity at `target`.
"""
function induced_vorticity(blob::GaussianVortexBlob{2}, target)
    _, distance_squared, radius_squared = blob_target_distance_setup_helper(blob, target)

    mollifier = exp(-distance_squared / (2 * radius_squared))

    vorticity = blob.circulation * mollifier / (radius_squared * pi * 2)

    return vorticity
end
