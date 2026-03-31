struct LagrangianFlowSolver{FP<:FlowProperties,ST<:SimulationTime,NC<:NumericalConfiguration}
    flow_properties::FP
    simulation_time::ST
    numerical_configuration::NC
end