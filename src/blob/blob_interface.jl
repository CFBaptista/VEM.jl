"""
    AbstractVortexBlob{Dimension, Scalar <: AbstractFloat}

Abstract type representing a vortex blob in `Dimension`-dimensional space, parameterized by a floating-point type `Scalar`.
"""
abstract type AbstractVortexBlob{Dimension,Scalar<:AbstractFloat} end

"""
    blob_dimension(blob::AbstractVortexBlob)

Return the spatial dimension of the given vortex blob.

# Arguments
- `blob::AbstractVortexBlob`: The vortex blob.

# Returns
The spatial dimension of the vortex blob.
"""
blob_dimension(::AbstractVortexBlob{Dimension}) where {Dimension} = Dimension

"""
    blob_scalar(blob::AbstractVortexBlob)

Return the floating-point type used for the data of the given vortex blob.

# Arguments
- `blob::AbstractVortexBlob`: The vortex blob.

# Returns
The floating-point type of the vortex blob data.
"""
blob_scalar(::AbstractVortexBlob{Dimension,Scalar}) where {Dimension,Scalar} = Scalar

"""
    blob_circulation(blob::AbstractVortexBlob)

Return the circulation carried by the vortex blob.

# Arguments
- `blob::AbstractVortexBlob`: The vortex blob.

# Returns
The circulation of the vortex blob.
"""
blob_circulation(blob::AbstractVortexBlob) = blob.circulation

"""
    blob_circulation!(blob::AbstractVortexBlob, new_circulation)

Update the circulation of the vortex blob.

# Arguments
- `blob::AbstractVortexBlob`: The vortex blob.
- `new_circulation`: The new circulation strength.
"""
function blob_circulation!(blob::AbstractVortexBlob, new_circulation)
    blob.circulation = new_circulation
    return nothing
end

"""
    blob_center(blob::AbstractVortexBlob)

Return the position of the vortex blob.

# Arguments
- `blob::AbstractVortexBlob`: The vortex blob.

# Returns
The position of the vortex blob.
"""
blob_center(blob::AbstractVortexBlob) = blob.center

"""
    blob_center!(blob::AbstractVortexBlob, new_center)

Update the position of the vortex blob.

# Arguments
- `blob::AbstractVortexBlob`: The vortex blob.
- `new_center`: The new vortex blob position.
"""
function blob_center!(blob::AbstractVortexBlob, new_center)
    blob.center = new_center
    return nothing
end

"""
    blob_radius(blob::AbstractVortexBlob)

Return the core radius of the vortex blob.

# Arguments
- `blob::AbstractVortexBlob`: The vortex blob.

# Returns
The core radius of the vortex blob.
"""
blob_radius(blob::AbstractVortexBlob) = blob.radius

"""
    blob_radius!(blob::AbstractVortexBlob, new_radius)

Update the core radius of the vortex blob.

# Arguments
- `blob::AbstractVortexBlob`: The vortex blob.
- `new_radius`: The new core radius.
"""
function blob_radius!(blob::AbstractVortexBlob, new_radius)
    blob.radius = new_radius
    return nothing
end
