"""
    GaussianVortexBlob(circulation::Union{Scalar,StaticArrays.SVector{Dimension,Scalar}}, center::StaticArrays.SVector{Dimension, Scalar}, radius::Scalar) where {Dimension, Scalar}
    GaussianVortexBlob(circulation, center, radius)

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
    _circulation = if isa(circulation, AbstractVector) && !isa(circulation, SA.SVector)
        SA.SVector(circulation...)
    else
        circulation
    end

    _center = if isa(center, AbstractVector) && !isa(center, SA.SVector)
        SA.SVector(center...)
    else
        center
    end

    return GaussianVortexBlob{length(_center),eltype(_center)}(_circulation, _center, radius)
end

"""
    induce(::VelocityField, blob::GaussianVortexBlob{2}, target)

Compute the velocity induced at `target` due to a 2D Gaussian vortex blob.

# Arguments
- `VelocityField`: The type of field to induce (velocity).
- `blob`: The vortex blob.
- `target`: The target position.

# Returns
The induced velocity at `target`.
"""
function induce(::VelocityField, blob::GaussianVortexBlob{2}, target)
    distance_squared, radius_squared, unscaled_influence, scaler, small_value = induced_velocity_setup_helper(
        blob, target
    )

    mollifier = 1 - exp(-distance_squared / (2 * radius_squared))

    velocity = induced_velocity_output_helper(unscaled_influence, scaler, mollifier, small_value)

    return velocity
end

"""
    induce(::VorticityField, blob::GaussianVortexBlob{2}, target)

Compute the vorticity induced at `target` due to a 2D Gaussian vortex blob.

# Arguments
- `VorticityField`: The type of field to induce (vorticity).
- `blob`: The vortex blob.
- `target`: The target position.

# Returns
The induced vorticity at `target`.
"""
function induce(::VorticityField, blob::GaussianVortexBlob{2}, target)
    distance_squared, radius_squared = induced_vorticity_input_helper(blob, target)

    mollifier = exp(-distance_squared / (2 * radius_squared))

    vorticity = induced_vorticity_output_helper(blob.circulation, mollifier, radius_squared)

    return vorticity
end
