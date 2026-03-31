"""
    NumericalConfiguration{AdvectionScheme<:ODE.OrdinaryDiffEqCore.OrdinaryDiffEqAlgorithm, DiffusionScheme<:ODE.OrdinaryDiffEqCore.OrdinaryDiffEqAlgorithm, RedistributionKernel<:AbstractRedistributionKernel, Float<:AbstractFloat}

A struct to hold the numerical configuration for the solver, including the advection and diffusion time schemes, the redistribution kernel, mesh spacing, overlap ratio, and population control threshold.

# Fields
- `advection_time_scheme`: The time-stepping scheme for advection.
- `diffusion_time_scheme`: The time-stepping scheme for diffusion.
- `redistribution_kernel`: The kernel used for redistribution.
- `mesh_spacing`: The spacing of the mesh.
- `overlap_ratio`: The ratio of overlap between mesh cells.
- `population_control_threshold`: The threshold for population control.
"""
struct NumericalConfiguration{
    AdvectionScheme<:ODE.OrdinaryDiffEqCore.OrdinaryDiffEqAlgorithm,
    DiffusionScheme<:ODE.OrdinaryDiffEqCore.OrdinaryDiffEqAlgorithm,
    RedistributionKernel<:AbstractRedistributionKernel,
    Float<:AbstractFloat,
}
    advection_time_scheme::AdvectionScheme
    diffusion_time_scheme::DiffusionScheme
    redistribution_kernel::RedistributionKernel
    mesh_spacing::Float
    overlap_ratio::Float
    population_control_threshold::Float

    function NumericalConfiguration{AdvectionScheme,DiffusionScheme,RedistributionKernel,Float}(
        advection_time_scheme,
        diffusion_time_scheme,
        redistribution_kernel,
        mesh_spacing,
        overlap_ratio,
        population_control_threshold,
    ) where {AdvectionScheme,DiffusionScheme,RedistributionKernel,Float}
        if mesh_spacing <= 0
            throw(ArgumentError("Mesh spacing must be positive."))
        end

        if overlap_ratio <= 0
            throw(ArgumentError("Overlap ratio must be positive."))
        end

        if population_control_threshold <= 0
            throw(ArgumentError("Population control threshold must be positive."))
        end

        return new{AdvectionScheme,DiffusionScheme,RedistributionKernel,Float}(
            advection_time_scheme,
            diffusion_time_scheme,
            redistribution_kernel,
            mesh_spacing,
            overlap_ratio,
            population_control_threshold,
        )
    end
end

"""
    NumericalConfiguration(mesh_spacing::Float; advection_time_scheme::ODE.OrdinaryDiffEqCore.OrdinaryDiffEqAlgorithm, diffusion_time_scheme::ODE.OrdinaryDiffEqCore.OrdinaryDiffEqAlgorithm, redistribution_kernel::AbstractRedistributionKernel, overlap_ratio::Float, population_control_threshold::Float)

A constructor for `NumericalConfiguration` that takes in the mesh spacing and optional parameters for the advection and diffusion time schemes, redistribution kernel, overlap ratio, and population control threshold. It returns an instance of `NumericalConfiguration` with the specified parameters.

# Arguments
- `mesh_spacing`: The spacing of the mesh (must be positive).
- `advection_time_scheme`: The time-stepping scheme for advection (default is `ODE.RK4()`).
- `diffusion_time_scheme`: The time-stepping scheme for diffusion (default is `ODE.RK4()`).
- `redistribution_kernel`: The kernel used for redistribution (default is `M4Prime()`).
- `overlap_ratio`: The ratio of overlap between mesh cells (default is `1.0`).
- `population_control_threshold`: The threshold for population control (default is `1e-6`).
"""
function NumericalConfiguration(
    mesh_spacing::Float;
    advection_time_scheme::ODE.OrdinaryDiffEqCore.OrdinaryDiffEqAlgorithm=ODE.RK4(),
    diffusion_time_scheme::ODE.OrdinaryDiffEqCore.OrdinaryDiffEqAlgorithm=ODE.RK4(),
    redistribution_kernel::AbstractRedistributionKernel=M4Prime(),
    overlap_ratio::Float=1.0,
    population_control_threshold::Float=1e-6,
)
    return NumericalConfiguration{
        typeof(advection_time_scheme),
        typeof(diffusion_time_scheme),
        typeof(redistribution_kernel),
        typeof(mesh_spacing),
    }(
        advection_time_scheme,
        diffusion_time_scheme,
        redistribution_kernel,
        mesh_spacing,
        overlap_ratio,
        population_control_threshold,
    )
end