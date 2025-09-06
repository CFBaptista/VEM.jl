"""
    induction_field_superposition(induction, blobs, targets)

Compute the superposition of fields induced by `blobs` at `targets`.

# Arguments
- `induction`: A function that computes the value induced by a blob at a target.
- `blobs`: An iterable collection of vortex blobs.
- `targets`: An iterable collection of targets.

# Returns
A vector where each entry corresponds to the superposition of inductions at a target.
"""
function induction_field_superposition(induction, blobs, targets)
    result = [mapreduce(induction, +, blobs, FA.Fill(target, length(blobs))) for target in targets]
    return result
end

"""
    induction_field_superposition(induction, blobs, target::AbstractVector{<:AbstractFloat})

Compute the superposition of fields induced by `blobs` at a single `target`.
"""
function induction_field_superposition(induction, blobs, target::AbstractVector{<:AbstractFloat})
    return induction_field_superposition(induction, blobs, tuple(target))
end

"""
    induction_field_superposition(induction, blob::AbstractVortexBlob, targets)

Compute the field induced by a `blob` at `targets`.
"""
function induction_field_superposition(induction, blob::AbstractVortexBlob, targets)
    return induction_field_superposition(induction, tuple(blob), targets)
end

"""
    induction_field_superposition(induction, blob::AbstractVortexBlob, target::AbstractVector{<:AbstractFloat})

Compute the value induced by a `blob` at a `target`.
"""
function induction_field_superposition(
    induction, blob::AbstractVortexBlob, target::AbstractVector{<:AbstractFloat}
)
    return induction_field_superposition(induction, tuple(blob), tuple(target))
end
