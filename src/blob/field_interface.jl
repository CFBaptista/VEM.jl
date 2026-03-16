"""
    AbstractInducedField

An abstract type representing the type of field to be induced by a vortex blob.
"""
abstract type AbstractInducedField end

"""
    VelocityField <: AbstractInducedField

A singleton type representing a velocity field.
"""
struct VelocityField <: AbstractInducedField end

"""
    field_scalar(::VelocityField, blob::AbstractVortexBlob)

Determine the scalar type of the velocity field induced by a vortex blob.

# Arguments
- `::VelocityField`: The type of field that is induced.
- `blob`: The vortex blob for which the field is being induced.

# Returns
The scalar type of the velocity field induced by the vortex blob.
"""
function field_scalar(
    ::VelocityField, blob::AbstractVortexBlob{Dimension,Scalar}
) where {Dimension,Scalar}
    return SA.SVector{Dimension,Scalar}
end

"""
    VorticityField <: AbstractInducedField          

A singleton type representing a vorticity field.
"""
struct VorticityField <: AbstractInducedField end

function field_scalar(
    ::VorticityField, blob::AbstractVortexBlob{Dimension,Scalar}
) where {Dimension,Scalar}
    if Dimension == 2
        return Scalar
    else
        return SA.SVector{Dimension,Scalar}
    end
end
