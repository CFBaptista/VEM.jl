"""
    AbstractVortexBlob{Dimension, Scalar <: AbstractFloat}

Abstract type representing a vortex blob in `Dimension`-dimensional space, parameterized by a floating-point type `Scalar`.
"""
abstract type AbstractVortexBlob{Dimension,Scalar<:AbstractFloat} end

"""
    Base.zero(::T) where {T<:AbstractVortexBlob}

Return a vortex blob with all data set to 0.

# Arguments
- `blob`: An instance of a vortex blob.

# Returns
A vortex blob instance with zero circulation, center, and radius.
"""
Base.zero(::T) where {T<:AbstractVortexBlob} = zero(T)

function Base.zeros(::Type{T}, dims::Dims) where {T<:AbstractVortexBlob}
    return [zero(T) for _ in CartesianIndices(dims)]
end

"""
    blob_dimension(blob::AbstractVortexBlob)

# Arguments
- `blob`: The vortex blob.

# Returns
The spatial dimension of the vortex blob.
"""
blob_dimension(::AbstractVortexBlob{Dimension}) where {Dimension} = Dimension

"""
    blob_scalar(blob::AbstractVortexBlob)

# Arguments
- `blob`: The vortex blob.

# Returns
The floating-point type of the vortex blob data.
"""
blob_scalar(::AbstractVortexBlob{Dimension,Scalar}) where {Dimension,Scalar} = Scalar

"""
    blob_circulation(blob::AbstractVortexBlob)

# Arguments
- `blob`: The vortex blob.

# Returns
The circulation of the vortex blob.
"""
blob_circulation(blob::AbstractVortexBlob) = blob.circulation

"""
    blob_circulation!(blob::AbstractVortexBlob, new_circulation)

Update the circulation of the vortex blob.

# Arguments
- `blob`: The vortex blob.
- `new_circulation`: The new circulation strength.
"""
function blob_circulation!(blob::AbstractVortexBlob, new_circulation)
    blob.circulation = new_circulation
    return nothing
end

"""
    blob_center(blob::AbstractVortexBlob)

# Arguments
- `blob`: The vortex blob.

# Returns
The position of the vortex blob.
"""
blob_center(blob::AbstractVortexBlob) = blob.center

"""
    blob_center!(blob::AbstractVortexBlob, new_center)

Update the position of the vortex blob.

# Arguments
- `blob`: The vortex blob.
- `new_center`: The new vortex blob position.
"""
function blob_center!(blob::AbstractVortexBlob, new_center)
    blob.center = new_center
    return nothing
end

"""
    blob_radius(blob::AbstractVortexBlob)

# Arguments
- `blob`: The vortex blob.

# Returns
The core radius of the vortex blob.
"""
blob_radius(blob::AbstractVortexBlob) = blob.radius

"""
    blob_radius!(blob::AbstractVortexBlob, new_radius)

Update the core radius of the vortex blob.

# Arguments
- `blob`: The vortex blob.
- `new_radius`: The new core radius.
"""
function blob_radius!(blob::AbstractVortexBlob, new_radius)
    blob.radius = new_radius
    return nothing
end
