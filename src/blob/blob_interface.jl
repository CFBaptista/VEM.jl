"""
    AbstractVortexBlob{Dimension, Scalar <: AbstractFloat}

Abstract type representing a vortex blob in `Dimension`-dimensional space, parameterized by a floating-point type `Scalar`.
"""
abstract type AbstractVortexBlob{Dimension,Scalar<:AbstractFloat} end

"""
    blob_dimension(blob::AbstractVortexBlob)

Return the spatial dimension of the given vortex blob type.
"""
blob_dimension(::AbstractVortexBlob{Dimension}) where {Dimension} = Dimension

"""
    blob_scalar(blob::AbstractVortexBlob)

Return the floating-point type used for the data of the given vortex blob type.
"""
blob_scalar(::AbstractVortexBlob{Dimension,Scalar}) where {Dimension,Scalar} = Scalar

"""
    blob_circulation(blob::AbstractVortexBlob)

Return the circulation carried by the vortex blob.
"""
blob_circulation(blob::AbstractVortexBlob) = blob.circulation

"""
    blob_center(blob::AbstractVortexBlob)

Return the position of the vortex blob.
"""
blob_center(blob::AbstractVortexBlob) = blob.center

"""
    blob_radius(blob::AbstractVortexBlob)

Return the core radius of the vortex blob.
"""
blob_radius(blob::AbstractVortexBlob) = blob.radius
