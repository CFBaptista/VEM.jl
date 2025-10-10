function induction_return_type(
    ::typeof(induced_velocity), ::Type{<:AbstractVortexBlob{Dimension,Scalar}}
) where {Dimension,Scalar}
    return SA.SVector{Dimension,Scalar}
end

function induction_return_type(
    ::typeof(induced_vorticity), ::Type{<:AbstractVortexBlob{2,Scalar}}
) where {Scalar}
    return Scalar
end

function induction_return_type(
    ::typeof(induced_vorticity), ::Type{<:AbstractVortexBlob{3,Scalar}}
) where {Scalar}
    return SA.SVector{3,Scalar}
end

function zero_field(induction::Function, blobs, targets)
    T = induction_return_type(induction, eltype(blobs))
    result = zeros(T, length(targets))
    return result
end

"""
    superpose_induced_fields(induction::Function, blobs, targets)
    superpose_induced_fields(induction::Function, blobs, target::AbstractVector{<:AbstractFloat})
    superpose_induced_fields(induction::Function, blob::AbstractVortexBlob, targets)
    superpose_induced_fields(induction::Function, blob::AbstractVortexBlob, target::AbstractVector{<:AbstractFloat})

Compute the superposition of fields induced by one or multiple `blobs` at on or multiple `targets`.

# Arguments
- `induction`: A function that computes the value induced by a blob at a target.
- `blobs`: An iterable collection of vortex blobs.
- `targets`: An iterable collection of targets.

# Returns
A vector where each entry corresponds to the superposition of inductions at a target.
"""
function superpose_induced_fields(induction::Function, blobs, targets)
    result = zero_field(induction, blobs, targets)
    superpose_induced_fields!(result, induction, blobs, targets)
    return result
end

function superpose_induced_fields(
    induction::Function, blobs, target::AbstractVector{<:AbstractFloat}
)
    return superpose_induced_fields(induction, blobs, tuple(target))
end

function superpose_induced_fields(induction::Function, blob::AbstractVortexBlob, targets)
    return superpose_induced_fields(induction, tuple(blob), targets)
end

function superpose_induced_fields(
    induction::Function, blob::AbstractVortexBlob, target::AbstractVector{<:AbstractFloat}
)
    return superpose_induced_fields(induction, tuple(blob), tuple(target))
end

"""
    superpose_induced_fields!(field, induction::Function, blobs, targets)
    superpose_induced_fields!(field, induction::Function, blob::AbstractVortexBlob, targets)
    superpose_induced_fields!(field, induction::Function, blobs, target::AbstractVector{<:AbstractFloat})
    superpose_induced_fields!(field, induction::Function, blob::AbstractVortexBlob, target::AbstractVector{<:AbstractFloat})

Compute the superposition of fields induced by one or multiple `blobs` at on or multiple `targets` in-place.

# Arguments
- `field`: The superimposed induced field.
- `induction`: A function that computes the value induced by a blob at a target.
- `blobs`: An iterable collection of vortex blobs.
- `targets`: An iterable collection of targets.
"""
function superpose_induced_fields!(field, induction::Function, blobs, targets)
    number_of_blobs = length(blobs)

    Threads.@threads for index in eachindex(targets)
        target = target_vector(targets, index, number_of_blobs)
        field[index] = mapreduce(induction, +, blobs, target)
    end

    return nothing
end

function target_vector(targets, index, size)
    target = targets[index]
    vector = FA.Fill(target, size)
    return vector
end

function superpose_induced_fields!(field, induction::Function, blob::AbstractVortexBlob, targets)
    superpose_induced_fields!(field, induction, tuple(blob), targets)
    return nothing
end

function superpose_induced_fields!(
    field, induction::Function, blobs, target::AbstractArray{<:AbstractFloat}
)
    superpose_induced_fields!(field, induction, blobs, tuple(target))
    return nothing
end

function superpose_induced_fields!(
    field, induction::Function, blob::AbstractVortexBlob, target::AbstractArray{<:AbstractFloat}
)
    superpose_induced_fields!(field, induction, tuple(blob), tuple(target))
    return nothing
end
