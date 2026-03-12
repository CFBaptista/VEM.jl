function interpolate_circulation(blobs, mesh::CartesianMesh, kernel::AbstractRedistributionKernel)
    if !inside_mesh(blobs, mesh)
        throw(ArgumentError("All blobs must reside within the redistribution mesh."))
    end

    mesh_dimensions = mesh_dimension(mesh)
    mesh_spacing = node_spacing(mesh)
    mesh_size = nodes_per_axis(mesh)

    core_radius = blob_radius(blobs[1])
    kernel_radius = support_radius(kernel)
    influence_radius = round(Int, kernel_radius * core_radius / mesh_spacing)

    redistributed_circulation = zeros(typeof(blob_circulation(blobs[1])), mesh_size)

    for blob in blobs
        circulation = blob_circulation(blob)
        center = blob_center(blob)

        reference_index = Tuple(floor(Int, x / mesh_spacing + 1) for x in center)
        min_index = Tuple(max(1, index - influence_radius + 1) for index in reference_index)
        max_index = Tuple(
            min(n, index + influence_radius) for (n, index) in zip(mesh_size, reference_index)
        )

        for index in CartesianIndex(min_index):CartesianIndex(max_index)
            weight = one(core_radius)

            for dimension in 1:mesh_dimensions
                source = center[dimension]
                target = (index[dimension] - 1) * mesh_spacing
                distance = (target - source) / core_radius
                weight *= redistribution_weight(kernel, distance)
            end

            redistributed_circulation[index] += circulation * weight
        end
    end

    return redistributed_circulation
end

function inside_mesh(blobs, mesh)
    blobs_extent = bounding_box(blob_center(blob) for blob in blobs)
    mesh_extent = mesh_bounds(mesh)

    for (x, y) in zip(blobs_extent, mesh_extent)
        if x[1] < y[1] || x[2] > y[2]
            return false
        end
    end

    return true
end