"""
    FlowProperties{Dimension,Float<:AbstractFloat}

A struct to hold the properties of the flow, such as density, kinematic viscosity, and freestream velocity. The `Dimension` type parameter indicates the dimensionality of the flow (e.g., 2D or 3D), while the `Float` type parameter specifies the floating-point type used for the properties (e.g., `Float64`).

# Fields
- `density`: The density of the fluid (must be positive).
- `kinematic_viscosity`: The kinematic viscosity of the fluid (must be positive).
- `freestream_velocity``: The freestream velocity of the flow.
"""
struct FlowProperties{Dimension,Float<:AbstractFloat}
    density::Float
    kinematic_viscosity::Float
    freestream_velocity::SA.SVector{Dimension,Float}

    function FlowProperties{Dimension,Float}(
        density, kinematic_viscosity, freestream_velocity
    ) where {Dimension,Float}
        if !(Dimension == 2 || Dimension == 3)
            throw(ArgumentError("Dimension must be either 2 or 3."))
        end

        if density <= 0
            throw(ArgumentError("Density must be positive."))
        end

        if kinematic_viscosity <= 0
            throw(ArgumentError("Kinematic viscosity must be positive."))
        end

        return new{Dimension,Float}(density, kinematic_viscosity, freestream_velocity)
    end
end

"""
    FlowProperties(density::Float=1.225, kinematic_viscosity::Float=1.46e-5, freestream_velocity::SA.SVector{Dimension,Float}=zero(SA.SVector{Dimension,Float})) where {Dimension,Float}

A constructor for `FlowProperties` that provides default values for air at sea level.

# Arguments
- `density``: The density of the fluid (default is 1.225).
- `kinematic_viscosity`: The kinematic viscosity of the fluid (default is 1.46e-5).
- `freestream_velocity`: The freestream velocity of the flow (default is a zero vector).

# Returns
- An instance of `FlowProperties` with the specified properties.
"""
function FlowProperties(density, kinematic_viscosity, freestream_velocity)
    return FlowProperties{Dimension,Float}(density, kinematic_viscosity, freestream_velocity)
end
