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
