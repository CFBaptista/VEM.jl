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

function update_centers!(blobs, new_centers)
    Threads.@threads for index in eachindex(blobs)
        blobs[index].center = new_centers[index]
    end

    return nothing
end
