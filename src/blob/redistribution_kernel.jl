"""
    AbstractRedistributionKernel

An abstract type representing a vortex blob redistribution kernel, which defines how weights are assigned based on distance normalized by the vortex blob core radius.
"""
abstract type AbstractRedistributionKernel end

"""
    M4Prime

M4' is a vortex blob redistribution kernel. It is defined by a piecewise function that assigns
weights based on the distance from the center of the vortex blob, normalized by the blob's core
radius. The M4' kernel has a support radius of 2, meaning that it assigns non-zero weights to points
at a distance greater than 2 core radii.
"""
struct M4Prime <: AbstractRedistributionKernel end

"""
    redistribution_weight(::M4Prime, distance)

Compute the redistribution weight for a given distance using the M4' kernel.

# Arguments
- `::M4Prime`: An instance of the M4' redistribution kernel.
- `distance`: The distance from the center of the vortex blob, normalized by the blob's core radius.

# Returns
The redistribution weight corresponding to the given distance.
"""
function redistribution_weight(::M4Prime, distance)
    distance = abs(distance)

    if distance <= 1
        return distance * (-distance * 5 / 2 + distance^2 * 3 / 2) + 1
    elseif distance <= 2
        return (1 - distance) * (2 - distance)^2 / 2
    else
        return zero(distance)
    end
end

"""
    support_radius(::M4Prime)

# Arguments
- `::M4Prime`: An instance of the M4' redistribution kernel.

# Returns
The support radius of the M4' redistribution kernel.
"""
support_radius(::M4Prime) = 2
