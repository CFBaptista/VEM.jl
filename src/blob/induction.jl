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
    T = Base.return_types(induction, (eltype(blobs), eltype(targets)))[1]
    result = zeros(T, length(targets))
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
    number_of_targets = length(targets)

    Threads.@threads for index in eachindex(targets)
        target = targets[index]
        target_vector = FA.Fill(target, number_of_targets)
        field[index] = mapreduce(induction, +, blobs, target_vector)
    end

    return nothing
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
