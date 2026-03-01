"""
    superpose_induced_fields(induction::Function, blobs, targets)

Compute the superposition of fields induced by one or multiple `blobs` at one or multiple `targets`.

# Arguments
- `induction`: A function that computes the value induced by a blob at a target.
- `blobs`: A single blob or an iterable collection of vortex blobs.
- `targets`: A single target or an iterable collection of targets.

# Returns
A vector where each entry corresponds to the superposition of inductions at a target.
"""
function superpose_induced_fields(induction::Function, blobs, targets)
    wrapped_blobs = wrap_induction_argument(blobs)
    wrapped_targets = wrap_induction_argument(targets)

    result = zero_field(induction, wrapped_blobs, wrapped_targets)
    superpose_induced_fields!(result, induction, wrapped_blobs, wrapped_targets)
    return result
end

"""
    superpose_induced_fields!(field, induction::Function, blobs, targets)

Compute the superposition of fields induced by one or multiple `blobs` at one or multiple `targets` in-place.

# Arguments
- `field`: The superimposed induced field.
- `induction`: A function that computes the value induced by a blob at a target.
- `blobs`: A single blob or an iterable collection of vortex blobs.
- `targets`: A single target or an iterable collection of targets.
"""
function superpose_induced_fields!(field, induction::Function, blobs, targets)
    wrapped_blobs = wrap_induction_argument(blobs)
    wrapped_targets = wrap_induction_argument(targets)

    number_of_blobs = length(wrapped_blobs)

    Threads.@threads for index in eachindex(wrapped_targets)
        target = FA.Fill(wrapped_targets[index], number_of_blobs)
        field[index] = mapreduce(induction, +, wrapped_blobs, target)
    end

    return nothing
end

wrap_induction_argument(blob::AbstractVortexBlob) = tuple(blob)
wrap_induction_argument(blobs::AbstractVector{<:AbstractVortexBlob}) = blobs
wrap_induction_argument(blob::Tuple{<:AbstractVortexBlob}) = blob
wrap_induction_argument(target::AbstractVector{<:AbstractFloat}) = tuple(target)
wrap_induction_argument(targets::AbstractVector{<:AbstractVector{<:AbstractFloat}}) = targets
wrap_induction_argument(targets::Tuple{<:AbstractVector{<:AbstractFloat}}) = targets

function zero_field(induction::Function, blobs, targets)
    T = induction_return_type(induction, eltype(blobs))
    result = zeros(T, length(targets))
    return result
end

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
