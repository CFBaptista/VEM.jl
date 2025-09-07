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
    induction_field_superposition(induction::Function, blobs, targets)

Compute the superposition of fields induced by `blobs` at `targets`.

# Arguments
- `induction::Function`: A function that computes the value induced by a blob at a target.
- `blobs`: An iterable collection of vortex blobs.
- `targets`: An iterable collection of targets.

# Returns
A vector where each entry corresponds to the superposition of inductions at a target.
"""
function induction_field_superposition(induction::Function, blobs, targets)
    result = zero_field(induction, blobs, targets)
    induction_field_superposition!(result, induction, blobs, targets)
    return result
end

"""
    induction_field_superposition(induction::Function, blobs, target::AbstractVector{<:AbstractFloat})

Compute the superposition of fields induced by `blobs` at a single `target`.
"""
function induction_field_superposition(
    induction::Function, blobs, target::AbstractVector{<:AbstractFloat}
)
    return induction_field_superposition(induction, blobs, tuple(target))
end

"""
    induction_field_superposition(induction::Function, blob::AbstractVortexBlob, targets)

Compute the field induced by a `blob` at `targets`.
"""
function induction_field_superposition(induction::Function, blob::AbstractVortexBlob, targets)
    return induction_field_superposition(induction, tuple(blob), targets)
end

"""
    induction_field_superposition(induction::Function, blob::AbstractVortexBlob, target::AbstractVector{<:AbstractFloat})

Compute the value induced by a `blob` at a `target`.
"""
function induction_field_superposition(
    induction::Function, blob::AbstractVortexBlob, target::AbstractVector{<:AbstractFloat}
)
    return induction_field_superposition(induction, tuple(blob), tuple(target))
end

"""
    induction_field_superposition!(field, induction::Function, blobs, targets)

Compute the superposition of fields induced by `blobs` at `targets` in-place.

# Arguments
- `field`: The superimposed induced field.
- `induction`: A function that computes the value induced by a blob at a target.
- `blobs`: An iterable collection of vortex blobs.
- `targets`: An iterable collection of targets.
"""
function induction_field_superposition!(field, induction::Function, blobs, targets)
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

"""
    induction_field_superposition!(field, induction::Function, blob::AbstractVortexBlob, targets)

Compute the field induced by a `blob` at `targets` in-place.
"""
function induction_field_superposition!(
    field, induction::Function, blob::AbstractVortexBlob, targets
)
    induction_field_superposition!(field, induction, tuple(blob), targets)
    return nothing
end

"""
    induction_field_superposition!(field, induction::Function, blobs, target::AbstractVector{<:AbstractFloat})

Compute the superposition of fields induced by `blobs` at a single `target` in-place.
"""
function induction_field_superposition!(
    field, induction::Function, blobs, target::AbstractArray{<:AbstractFloat}
)
    induction_field_superposition!(field, induction, blobs, tuple(target))
    return nothing
end

"""
    induction_field_superposition!(field, induction::Function, blob::AbstractVortexBlob, target::AbstractVector{<:AbstractFloat})

Compute the value induced by a `blob` at a `target` in-place.
"""
function induction_field_superposition!(
    field, induction::Function, blob::AbstractVortexBlob, target::AbstractArray{<:AbstractFloat}
)
    induction_field_superposition!(field, induction, tuple(blob), tuple(target))
    return nothing
end
