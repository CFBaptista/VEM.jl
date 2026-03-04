"""
    direct_sum(induced_field::AbstractInducedField, blobs, targets)

Compute the superposition of fields induced by one or multiple `blobs` at one or multiple `targets`.

# Arguments
- `induced_field`: The type of field to be induced by the blobs.
- `blobs`: A single blob or an iterable collection of vortex blobs.
- `targets`: A single target or an iterable collection of targets.

# Returns
A vector where each entry corresponds to the superposition of inductions at a target.
"""
function direct_sum(induced_field::AbstractInducedField, blobs, targets)
    wrapped_blobs = wrap_induction_argument(blobs)
    wrapped_targets = wrap_induction_argument(targets)

    result = zero_field(induced_field, wrapped_blobs, wrapped_targets)
    direct_sum!(result, induced_field, wrapped_blobs, wrapped_targets)
    return result
end

"""
    direct_sum!(field, induced_field::AbstractInducedField, blobs, targets)

Compute the superposition of fields induced by one or multiple `blobs` at one or multiple `targets` in-place.

# Arguments
- `field`: The superimposed induced field.
- `induced_field`: The type of field to be induced by the blobs.
- `blobs`: A single blob or an iterable collection of vortex blobs.
- `targets`: A single target or an iterable collection of targets.
"""
function direct_sum!(field, induced_field::AbstractInducedField, blobs, targets)
    wrapped_blobs = wrap_induction_argument(blobs)
    wrapped_targets = wrap_induction_argument(targets)

    number_of_blobs = length(wrapped_blobs)
    _induced_field = FA.Fill(induced_field, number_of_blobs)

    Threads.@threads for index in eachindex(wrapped_targets)
        target = FA.Fill(wrapped_targets[index], number_of_blobs)
        field[index] = mapreduce(induce, +, _induced_field, wrapped_blobs, target)
    end

    return nothing
end

function zero_field(induced_field::AbstractInducedField, blobs, targets)
    return zeros(field_scalar(induced_field, blobs[1]), length(targets))
end

wrap_induction_argument(blob::AbstractVortexBlob) = tuple(blob)
wrap_induction_argument(blobs::AbstractVector{<:AbstractVortexBlob}) = blobs
wrap_induction_argument(blob::Tuple{<:AbstractVortexBlob}) = blob
wrap_induction_argument(target::AbstractVector{<:AbstractFloat}) = tuple(target)
wrap_induction_argument(targets::AbstractVector{<:AbstractVector{<:AbstractFloat}}) = targets
wrap_induction_argument(targets::Tuple{<:AbstractVector{<:AbstractFloat}}) = targets
