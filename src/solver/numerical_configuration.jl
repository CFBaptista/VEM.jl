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