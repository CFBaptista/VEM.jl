function planar_cross(scalar, vector)
    result = typeof(vector)(-scalar * vector[2], scalar * vector[1])
    return result
end

function blob_target_distance_setup_helper(blob::AbstractVortexBlob{2}, target)
    distance = target - blob.center
    distance_squared = LA.dot(distance, distance)
    radius_squared = blob.radius^2

    return distance, distance_squared, radius_squared
end

function induced_velocity_setup_helper(blob::AbstractVortexBlob{2}, target)
    distance, distance_squared, radius_squared = blob_target_distance_setup_helper(blob, target)

    unscaled_influence = planar_cross(blob.circulation, distance)
    scaler = distance_squared * pi * 2
    small_value = eps(eltype(target))

    return distance_squared, radius_squared, unscaled_influence, scaler, small_value
end

function induced_velocity_output_helper(unscaled_influence, scaler, mollifier, small_value)
    velocity = unscaled_influence * (mollifier / (scaler + small_value))
    return velocity
end

function induced_vorticity_input_helper(blob::AbstractVortexBlob{2}, target)
    _, distance_squared, radius_squared = blob_target_distance_setup_helper(blob, target)
    return distance_squared, radius_squared
end

function induced_vorticity_output_helper(circulation, mollifier, radius_squared)
    vorticity = circulation * (mollifier / (radius_squared * pi * 2))
    return vorticity
end

function bounding_box(points)
    minimum = reduce((x, y) -> min.(x, y), points)
    maximum = reduce((x, y) -> max.(x, y), points)
    extent = ((x, y) for (x, y) in zip(minimum, maximum))
    return extent
end
