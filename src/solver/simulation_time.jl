"""
    SimulationTime{Float<:AbstractFloat}(start_time::Float, time_step::Float, number_of_steps::Int)

A structure to manage the simulation time.

# Fields
- `start_time`: The initial time of the simulation (must be non-negative).
- `time_step`: The time increment for each simulation step (must be positive).
- `number_of_steps`: The total number of steps to simulate (must be positive).
- `current_step`: The current step of the simulation (must be between 0 and number of steps).
"""
mutable struct SimulationTime{Float<:AbstractFloat}
    const start_time::Float
    const time_step::Float
    const number_of_steps::Int
    current_step::Int

    function SimulationTime{Float}(
        start_time, time_step, number_of_steps, current_step
    ) where {Float}
        if start_time < 0
            throw(ArgumentError("Start time must be non-negative."))
        end

        if time_step <= 0
            throw(ArgumentError("Time step must be positive."))
        end

        if number_of_steps <= 0
            throw(ArgumentError("Number of steps must be positive."))
        end

        if current_step < 0 || current_step > number_of_steps
            throw(ArgumentError("Current step must be between 0 and number of steps."))
        end

        return new{Float}(start_time, time_step, number_of_steps, current_step)
    end
end

"""
    SimulationTime(time_step::Float, number_of_steps::Int; start_time::Float=0.0, current_step::Int=0) where {Float<:AbstractFloat}

A constructor for `SimulationTime` that initializes the structure with the given parameters.

# Arguments
- `time_step`: The time increment for each simulation step.
- `number_of_steps`: The total number of steps to simulate.
- `start_time`: The initial time of the simulation (default is 0.0).
- `current_step`: The current step of the simulation (default is 0).

# Returns
An instance of `SimulationTime` initialized with the provided parameters.
"""
function SimulationTime(
    time_step::Float, number_of_steps::Int; start_time::Float=0.0, current_step::Int=0
) where {Float<:AbstractFloat}
    return SimulationTime{Float}(start_time, time_step, number_of_steps, current_step)
end

"""
    current_time(time::SimulationTime)

Compute the current simulation time based on the `start_time`, `time_step`, and `current_step`.

# Arguments
- `time`: An instance of `SimulationTime`.

# Returns
The current simulation time as a `Float`.
"""
current_time(time::SimulationTime) = time.start_time + time.current_step * time.time_step

"""
    end_time(time::SimulationTime)

Compute the end time of the simulation based on the `start_time`, `time_step`, and `number_of_steps`.

# Arguments
- `time`: An instance of `SimulationTime`.

# Returns
The end time of the simulation as a `Float`.
"""
end_time(time::SimulationTime) = time.start_time + time.number_of_steps * time.time_step

"""
    advance!(time::SimulationTime)

Update the simulation time by incrementing the `current_step` by 1.

# Arguments
- `time`: An instance of `SimulationTime` to be updated.
"""
advance!(time::SimulationTime) = time.current_step += 1

"""
    running(time::SimulationTime)

Check if the simulation should continue running based on the `current_step` and `number_of_steps`.

# Arguments
- `time`: An instance of `SimulationTime`.

# Returns
A boolean indicating whether the simulation should continue running (`true`) or has completed (`false`).
"""
running(time::SimulationTime) = time.current_step < time.number_of_steps
