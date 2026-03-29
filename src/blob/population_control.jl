"""
    population_control!(blobs, tolerance)

Prune vortex blobs based on their circulation magnitude to maintain a manageable population size.
The pruning procedure ensures that the sum of circulation magnitude removed is smaller than the specified tolerance multiplied by the sum of all circulation magnitudes.

# Arguments
- `blobs`: A collection of vortex blobs.
- `tolerance`: A scalar value that determines a relative threshold for pruning.

# Returns
- `removed_circulation`: The total circulation removed due to pruning.
"""
function population_control!(blobs, tolerance)
    removed_circulation = zero(blob_scalar(first(blobs)))

    zero_indices = findall(x -> blob_circulation(x) == 0, blobs)
    deleteat!(blobs, zero_indices)

    if isempty(blobs)
        return removed_circulation
    end

    circulation_magnitudes = map(x -> LA.norm(blob_circulation(x)), blobs)
    circulation_magnitude_sum = sum(circulation_magnitudes)

    accumulation = zero(circulation_magnitude_sum)
    threshold = tolerance * circulation_magnitude_sum

    for circulation_magnitude in sort(circulation_magnitudes)
        if accumulation + circulation_magnitude > threshold
            remove_indices = findall(x -> x < circulation_magnitude, circulation_magnitudes)
            removed_circulation = sum(index -> blob_circulation(blobs[index]), remove_indices)
            deleteat!(blobs, remove_indices)
            break
        end
        accumulation += circulation_magnitude
    end

    return removed_circulation
end
