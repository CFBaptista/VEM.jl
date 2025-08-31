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
    blob_circulation!(blob::AbstractVortexBlob, new_circulation)

Update the circulation of the vortex blob.
"""
function blob_circulation!(blob::AbstractVortexBlob, new_circulation)
    return blob.circulation = new_circulation
end

"""
    blob_center(blob::AbstractVortexBlob)

Return the position of the vortex blob.
"""
blob_center(blob::AbstractVortexBlob) = blob.center

"""
    blob_center!(blob::AbstractVortexBlob, new_center)

Update the position of the vortex blob.
"""
function blob_center!(blob::AbstractVortexBlob, new_center)
    return blob.center = new_center
end

"""
    blob_radius(blob::AbstractVortexBlob)

Return the core radius of the vortex blob.
"""
blob_radius(blob::AbstractVortexBlob) = blob.radius

"""
    blob_radius!(blob::AbstractVortexBlob, new_radius)

Update the core radius of the vortex blob.
"""
function blob_radius!(blob::AbstractVortexBlob, new_radius)
    return blob.radius = new_radius
end
