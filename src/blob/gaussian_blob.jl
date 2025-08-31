"""
    GaussianVortexBlob(circulation::Scalar, center::SA.SVector{Dimension, Scalar}, radius::Scalar) where {Dimension, Scalar}

A smooth vortex blob with a Gaussian mollifier kernel. It is characterized by the amount of
circulation it carries, a position and a finite core radius.

# Arguments
- `circulation::Scalar`: The circulation strength of the vortex blob.
- `center::SA.SVector{Dimension, Scalar}`: The position of the blob center.
- `radius::Scalar`: The core radius of the blob.

# Returns
A `GaussianVortexBlob` instance.
"""
mutable struct GaussianVortexBlob{Dimension,Scalar} <: AbstractVortexBlob{Dimension,Scalar}
    circulation::Scalar
    center::SA.SVector{Dimension,Scalar}
    radius::Scalar
end

"""
    GaussianVortexBlob(circulation, center::Tuple, radius)

Construct a `GaussianVortexBlob` when `center` is supplied as a type that is convertible to SA.SVector.
"""
function GaussianVortexBlob(circulation, center, radius)
    return GaussianVortexBlob(circulation, SA.SVector(Tuple(center)), radius)
end

"""
    GaussianVortexBlob(circulation, center::Tuple, radius)

Construct a `GaussianVortexBlob` when `center` is supplied as Tuple.
"""
function GaussianVortexBlob(circulation, center::Tuple, radius)
    return GaussianVortexBlob(circulation, SA.SVector(center), radius)
end

"""
    GaussianVortexBlob(circulation, center::Tuple, radius)

Construct a `GaussianVortexBlob` when `center` is supplied as SA.SVector.
"""
function GaussianVortexBlob(circulation, center::SA.SVector, radius)
    return GaussianVortexBlob(circulation, center, radius)
end

"""
    induced_velocity(blob::GaussianVortexBlob{2}, target)

Compute the velocity induced at a target point by a 2D Gaussian vortex blob.

# Arguments
- `blob::GaussianVortexBlob{2}`: The vortex blob.
- `target`: The target position.

# Returns
The induced velocity at the target position.
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
    distance = target - blob.center
    distance_squared = LA.dot(distance, distance)
    radius_squared = blob.radius^2

    unscaled_influence = planar_cross(blob.circulation, distance)
    scaler = distance_squared * pi * 2
    small_value = eps(eltype(target))

    return distance_squared, radius_squared, unscaled_influence, scaler, small_value
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

Compute the vorticity induced at a target point by a 2D Gaussian vortex blob.

# Arguments
- `blob::GaussianVortexBlob{2}`: The vortex blob.
- `target`: The target position.

# Returns
The induced vorticity at the target position.
"""
function induced_vorticity(blob::GaussianVortexBlob{2}, target)
    distance = target - blob.center
    distance_squared = LA.dot(distance, distance)
    radius_squared = blob.radius^2

    mollifier = exp(-distance_squared / (2 * radius_squared))

    vorticity = blob.circulation * mollifier / (radius_squared * pi * 2)

    return vorticity
end
