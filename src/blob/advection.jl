"""
    advection!(blobs, time, time_step; time_scheme=ODE.RK4())

Advances the position of a collection of blobs by a single time step according to the local velocity field induced by the collection.
The positions of the blobs are updated in-place.

# Arguments
- `blobs`: An iterable collection of vortex blobs.
- `time`: The time at the start of a time step.
- `time_step`: The time increment over a single step.
- `time_scheme`: (Optional) The time integration scheme to use. Defaults to `ODE.RK4()` (classical Runge-Kutta 4th order).
"""
function advection!(blobs, time, time_step; time_scheme=ODE.RK4())
    time_span = (time, time + time_step)
    initial_condition = getfield.(blobs, :center)

    problem = ODE.ODEProblem(
        advection_operator!, RAT.VectorOfArray(initial_condition), time_span, blobs
    )
    ODE.solve(problem, time_scheme; dt=time_step, adaptive=false)

    return nothing
end

function advection_operator!(du, u, p, t)
    update_centers!(p, u)
    superpose_induced_fields!(du, induced_velocity, p, u)
    return nothing
end

function update_centers!(blobs, new_centers::RAT.VectorOfArray)
    for index in eachindex(blobs)
        @inbounds blobs[index].center = new_centers.u[index]
    end

    return nothing
end
