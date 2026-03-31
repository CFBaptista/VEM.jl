"""
    LagrangianFlowSolver{FP<:FlowProperties,ST<:SimulationTime,NC<:NumericalConfiguration}

A struct to hold the Lagrangian flow solver.

# Fields
- `vortex_blobs`: A vector of vortex blobs representing the flow field.
- `flow_properties`: The properties of the flow being simulated.
- `simulation_time`: The time configuration for the simulation.
- `numerical_configuration`: The numerical configuration for the solver.
"""
struct LagrangianFlowSolver{
    VB<:AbstractVortexBlob,FP<:FlowProperties,ST<:SimulationTime,NC<:NumericalConfiguration
}
    vortex_blobs::Vector{VB}
    flow_properties::FP
    simulation_time::ST
    numerical_configuration::NC
end

"""
    evolve!(solver::LagrangianFlowSolver)

Evolve the flow field using the Lagrangian flow solver.

# Arguments
- `solver`: An instance of `LagrangianFlowSolver` containing the vortex blobs, flow properties, simulation time, and numerical configuration.
"""
function evolve!(solver::LagrangianFlowSolver)
    blobs = solver.vortex_blobs
    flow = solver.flow_properties
    time = solver.simulation_time
    configuration = solver.numerical_configuration

    while running(time)
        advance!(time)

        advection!(
            blobs,
            current_time(time),
            time_step(time);
            time_scheme=configuration.advection_time_scheme,
        )

        mesh = redistribution_mesh(blobs, configuration.mesh_spacing, configuration.overlap_ratio)

        redistribution!(blobs, mesh, configuration, redistribution_kernel)

        diffusion!(
            blobs,
            flow.kinematic_viscosity,
            mesh,
            current_time(time),
            time.time_step;
            time_scheme=configuration.diffusion_time_scheme,
        )

        population_control!(blobs, configuration.population_control_threshold)
    end
end
