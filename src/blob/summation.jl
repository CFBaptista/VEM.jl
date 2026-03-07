"""
    direct_sum(induced_field::AbstractInducedField, blobs, targets)

Compute the superposition of fields induced by a collection of `blobs` at a collection of `targets` (out-of-place).

# Arguments
- `induced_field`: The type of field to be induced by the blobs.
- `blobs`: A single blob or an iterable collection of vortex blobs.
- `targets`: A single target or an iterable collection of targets.

# Returns
A vector where each entry corresponds to the superposition of inductions at a target.
"""
function direct_sum(induced_field::AbstractInducedField, blobs, targets)
    _blobs = wrap_induction_argument(blobs)
    _targets = wrap_induction_argument(targets)

    field = zero_field(induced_field, _blobs, _targets)
    direct_sum!(field, induced_field, _blobs, _targets)

    return field
end

"""
    direct_sum!(field, induced_field::AbstractInducedField, blobs, targets)

Compute the superposition of fields induced by a collection of `blobs` at a collection of `targets` (in-place).

# Arguments
- `field`: The superimposed induced field.
- `induced_field`: The type of field to be induced by the blobs.
- `blobs`: A single blob or an iterable collection of vortex blobs.
- `targets`: A single target or an iterable collection of targets.
"""
function direct_sum!(field, induced_field::AbstractInducedField, blobs, targets)
    _blobs = wrap_induction_argument(blobs)
    _targets = wrap_induction_argument(targets)

    number_of_blobs = length(_blobs)
    _induced_field = FA.Fill(induced_field, number_of_blobs)

    Threads.@threads for index in eachindex(_targets)
        _target = FA.Fill(_targets[index], number_of_blobs)
        field[index] = mapreduce(induce, +, _induced_field, _blobs, _target)
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
