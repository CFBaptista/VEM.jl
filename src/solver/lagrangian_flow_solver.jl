"""
    LagrangianFlowSolver{FP<:FlowProperties,ST<:SimulationTime,NC<:NumericalConfiguration}

A struct to hold the Lagrangian flow solver, which includes the flow properties, simulation time, and numerical configuration.

# Fields
- `flow_properties`: The properties of the flow being simulated.
- `simulation_time`: The time configuration for the simulation.
- `numerical_configuration`: The numerical configuration for the solver.
"""
struct LagrangianFlowSolver{FP<:FlowProperties,ST<:SimulationTime,NC<:NumericalConfiguration}
    flow_properties::FP
    simulation_time::ST
    numerical_configuration::NC
end
