"""
    diffusion!(blobs, viscosity, mesh, time, time_step; time_scheme=ODE.RK4())

Apply diffusion to the given blobs over a time step using the specified time integration scheme.

# Arguments
- `blobs`: A collection of blobs.
- `viscosity`: The fluid viscosity.
- `mesh`: The Cartesian mesh whose nodes are the locations of the blobs.
- `time`: The time at the start of the time step.
- `time_step`: The time increment for diffusion.
- `time_scheme`: (Optional) The time integration scheme to use, default is `ODE.RK4()`.
"""
function diffusion!(blobs, viscosity, mesh, time, time_step; time_scheme=ODE.RK4())
    initial_condition = blob_circulation.(blobs)
    time_span = (time, time + time_step)
    kernel = laplacian_kernel(viscosity, mesh)

    problem = ODE.ODEProblem(laplacian!, initial_condition, time_span, kernel)
    solution = ODE.solve(problem, time_scheme; dt=time_step, adaptive=false)

    for (blob, circulation) in zip(blobs, solution.u[end])
        blob_circulation!(blob, circulation)
    end

    return nothing
end

function laplacian_kernel(viscosity, mesh)
    spacing = node_spacing(mesh)

    if mesh_dimension(mesh) == 2
        factor = viscosity / (6 * spacing^2)

        center = -20 * factor
        edge = 4 * factor
        corner = factor

        kernel = [corner edge corner; edge center edge; corner edge corner]
    else
        throw(ArgumentError("Cartesian mesh dimension must be 2, not $(mesh_dimension(mesh))."))
    end

    return IF.centered(kernel)
end

function laplacian!(du, u, p, t)
    kernel = p
    du .= IF.imfilter(u, kernel)
    return nothing
end
