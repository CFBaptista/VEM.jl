@testitem "Create blob with center::Tuple (2D)" begin
    # GIVEN

    center = (0.5, 0.5)

    # WHEN / THEN

    @test begin
        blob = GaussianVortexBlob(1.0, center, 1.0)
        true
    end
end

@testitem "Create blob with center::Vector (2D)" begin
    # GIVEN

    center = [0.5, 0.5]

    # WHEN / THEN

    @test begin
        blob = GaussianVortexBlob(1.0, center, 1.0)
        true
    end
end

@testitem "Create blob with center::SVector (2D)" begin
    # GIVEN

    center = VEM.SA.SVector(0.5, 0.5)

    # WHEN / THEN

    @test begin
        blob = GaussianVortexBlob(1.0, center, 1.0)
        true
    end
end

@testitem "Cannot create blob with mixed floating-point types (2D)" begin
    # GIVEN

    circulation = Float64(1)
    center = Float32[2, 3]
    radius = Float16(4)

    # WHEN / THEN

    @test_throws MethodError blob = GaussianVortexBlob(circulation, center, radius)
end

@testitem "Cannot create blob with scalar circulation and 3D position" begin
    # GIVEN

    circulation = 0.23024673335450663
    center = [0.24312257710823948, 0.5346144057331608, 0.5074864635308087]
    radius = 0.5829689502123744

    # WHEN / THEN

    @test_throws ArgumentError blob = GaussianVortexBlob(circulation, center, radius)
end

@testitem "Cannot create blob with 3D circulation and 2D position" begin
    # GIVEN

    circulation = [0.11337262536359693, 0.28145956014569606, 0.4192211746213216]
    center = [0.8164371245291423, 0.3580579843840971, 0.5074864635308087]
    radius = 0.6630371529700086

    # WHEN / THEN

    @test_throws MethodError blob = GaussianVortexBlob(circulation, center, radius)
end

@testsnippet GaussianVortexBlob2D begin
    expected_dimension = 2
    expected_scalar = Float64
    expected_circulation = 0.6822289008065964
    expected_center = [0.4266967221161493, 0.9585154998556389]
    expected_radius = 0.742102927541106

    target = [0.37910466032881385, 0.25319562281414765]

    blob = GaussianVortexBlob(expected_circulation, expected_center, expected_radius)
end

@testitem "Get vortex blob dimension (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    # WHEN

    dimension = blob_dimension(blob)

    # THEN

    @test dimension == expected_dimension
end

@testitem "Get vortex blob scalar (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    # WHEN

    scalar = blob_scalar(blob)

    # THEN

    @test scalar == expected_scalar
end

@testitem "Get vortex blob circulation (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    # WHEN

    circulation = blob_circulation(blob)

    # THEN

    @test circulation == expected_circulation
end

@testitem "Update vortex blob circulation (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    new_circulation = 1.0

    # WHEN

    blob_circulation!(blob, new_circulation)

    # THEN

    @test blob_circulation(blob) == new_circulation
end

@testitem "Get vortex blob center (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    # WHEN

    center = blob_center(blob)

    # THEN

    @test center == expected_center
end

@testitem "Update vortex blob center (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    new_center = (0.5, 0.5)

    # WHEN

    blob_center!(blob, new_center)

    # THEN

    @test all(blob_center(blob) .== new_center)
end

@testitem "Get vortex blob radius (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    # WHEN

    radius = blob_radius(blob)

    # THEN

    @test radius == expected_radius
end

@testitem "Update vortex blob radius (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    new_radius = 1.0

    # WHEN

    blob_radius!(blob, new_radius)

    # THEN

    @test blob_radius(blob) == new_radius
end

@testitem "Induced velocity is proportional to circulation (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    factor = 0.9545476135575189

    # WHEN

    old_velocity = induced_velocity(blob, target)
    blob_circulation!(blob, factor * blob_circulation(blob))
    new_velocity = induced_velocity(blob, target)

    # THEN

    @test isapprox(factor * old_velocity, new_velocity; rtol=1e-15)
end

@testitem "Positive circulation induces counter-clockwise velocity (2D)" setup = [
    GaussianVortexBlob2D
] begin
    # GIVEN

    target = blob_center(blob) + [0.5, 0.5]
    circulation_sign = sign(blob_circulation(blob))

    # WHEN

    velocity = induced_velocity(blob, target)

    # THEN

    @test circulation_sign * velocity[1] < 0
    @test circulation_sign * velocity[2] > 0
end

@testitem "Induced velocity magnitude away from center is larger than zero (2D)" setup = [
    GaussianVortexBlob2D
] begin
    # GIVEN

    target = blob_center(blob) + [0.05857383934234839, 0.4087109412556016]

    # WHEN

    velocity = induced_velocity(blob, target)
    velocity_magnitude = VEM.LA.norm(velocity)

    # THEN

    @test velocity_magnitude > 0.0
end

@testitem "Induced velocity at distance greater than 3 core radii scales approximately inverse proportional with distance (2D)" setup = [
    GaussianVortexBlob2D
] begin
    # GIVEN

    direction = [0.606593953699998, 0.7950118082988482]
    target_1 = blob_center(blob) + 3 * direction
    target_2 = blob_center(blob) + 4 * direction

    # WHEN

    velocity_1 = induced_velocity(blob, target_1)
    velocity_2 = induced_velocity(blob, target_2)

    distance_1 = target_1 - blob_center(blob)
    distance_2 = target_2 - blob_center(blob)

    ratio_distance = VEM.LA.norm(distance_2) / VEM.LA.norm(distance_1)
    ratio_velocity = VEM.LA.norm(velocity_2) / VEM.LA.norm(velocity_1)

    # THEN

    @test isapprox(1 / ratio_distance, ratio_velocity; rtol=1e-3)
end

@testitem "Induced velocity is perpendicular to distance vector (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    target = blob_center(blob) + [0.09942340947611172, 0.5730399377638032]

    # WHEN

    velocity = induced_velocity(blob, target)
    distance = target - blob_center(blob)

    # THEN

    @test isapprox(VEM.LA.dot(velocity, distance), 0.0; atol=1e-15)
end

@testitem "Induced velocity magnitude increases between r = 0 and r = 1.5 core radii (2D)" setup = [
    GaussianVortexBlob2D
] begin
    # GIVEN

    direction = [0.9660708051919009, 0.25827736903544635]
    target_1 = blob_center(blob) + 0.5 * blob_radius(blob) * direction
    target_2 = blob_center(blob) + 1.0 * blob_radius(blob) * direction
    target_3 = blob_center(blob) + 1.5 * blob_radius(blob) * direction

    # WHEN

    velocity_1 = induced_velocity(blob, target_1)
    velocity_2 = induced_velocity(blob, target_2)
    velocity_3 = induced_velocity(blob, target_3)

    # THEN

    @test VEM.LA.norm(velocity_3) > VEM.LA.norm(velocity_2) > VEM.LA.norm(velocity_1)
end

@testitem "Induced velocity at the center is finite (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    # WHEN

    velocity = induced_velocity(blob, blob_center(blob))

    # THEN

    @test all(isfinite, velocity)
end

@testitem "Induced velocity at the center is zero (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    # WHEN

    velocity = induced_velocity(blob, blob_center(blob))

    # THEN

    @test all(isapprox.(velocity, 0.0; atol=1e-15))
end

@testitem "Induced velocity magnitude at r = core radius due to blob of unit circulation and unit radius equals (1 - exp(-1/2)) / (2*pi)" begin
    # GIVEN

    circulation = 1.0
    center = [0.01943447161583367, 0.9318904766600706]
    radius = 1.0
    blob = GaussianVortexBlob(circulation, center, radius)

    expected_velocity_magnitude = (1 - exp(-1 / 2)) / (2 * pi)

    # WHEN

    target = blob_center(blob) + [radius, 0.0]
    velocity = induced_velocity(blob, target)

    # THEN

    @test isapprox(VEM.LA.norm(velocity), expected_velocity_magnitude; rtol=1e-15)
end

@testitem "Induced velocity type is the expected type" begin
    T = (Float16, Float32, Float64, BigFloat)

    for T1 in T
        for T2 in T
            circulation = rand(T1)
            center = rand(T1, 2)
            radius = rand(T1)

            blob = GaussianVortexBlob(circulation, center, radius)
            target = rand(T2, 2)
            scalar = promote_type(T1, T2)

            @test induced_velocity(blob, target) isa VEM.SA.SVector{2,scalar}
        end
    end
end

@testitem "Induced vorticity is proportional to circulation (2D)" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    factor = 0.14350917205481295

    # WHEN

    old_vorticity = induced_vorticity(blob, target)
    blob_circulation!(blob, factor * blob_circulation(blob))
    new_vorticity = induced_vorticity(blob, target)

    # THEN

    @test isapprox(factor * old_vorticity, new_vorticity; rtol=1e-15)
end

@testitem "Induced vorticity at center equals circulation / (2 * pi * radius^2)" setup = [
    GaussianVortexBlob2D
] begin
    # GIVEN

    expected_vorticity = blob_circulation(blob) / (2 * pi * blob_radius(blob)^2)

    # WHEN

    vorticity = induced_vorticity(blob, blob_center(blob))

    # THEN

    @test isapprox(vorticity, expected_vorticity; rtol=1e-15)
end

@testitem "Induced vorticity decays exponentially with distance squared (2D)" setup = [
    GaussianVortexBlob2D
] begin
    # GIVEN

    direction = [0.8245975544929167, 0.5657197832180709]

    target_1 = blob_center(blob) + 0.7125797684853538 * direction
    distance_1 = target_1 - blob_center(blob)
    distance_square_1 = VEM.LA.dot(distance_1, distance_1)

    target_2 = blob_center(blob) + 2.4959348158824275 * direction
    distance_2 = target_2 - blob_center(blob)
    distance_square_2 = VEM.LA.dot(distance_2, distance_2)

    expected_ratio = exp(-(distance_square_2 - distance_square_1) / (2 * blob_radius(blob)^2))

    # WHEN

    vorticity_1 = induced_vorticity(blob, target_1)
    vorticity_2 = induced_vorticity(blob, target_2)

    # THEN

    @test isapprox(vorticity_2 / vorticity_1, expected_ratio; rtol=1e-15)
end

@testitem "Induced vorticity type is the expected type" begin
    T = (Float16, Float32, Float64, BigFloat)

    for T1 in T
        for T2 in T
            circulation = rand(T1)
            center = rand(T1, 2)
            radius = rand(T1)

            blob = GaussianVortexBlob(circulation, center, radius)
            target = rand(T2, 2)
            scalar = promote_type(T1, T2)

            @test induced_vorticity(blob, target) isa scalar
        end
    end
end

@testitem "Induced velocity is consistent with induced vorticity" setup = [GaussianVortexBlob2D] begin
    # GIVEN

    target = blob_center(blob) + [0.7903753220899068, 0.20269405341897373]
    expected_vorticity = induced_vorticity(blob, target)

    spacing = 1e-6

    # WHEN

    target_x_plus = target + [spacing, 0.0]
    target_x_minus = target - [spacing, 0.0]
    target_y_plus = target + [0.0, spacing]
    target_y_minus = target - [0.0, spacing]

    velocity_x_plus = induced_velocity(blob, target_x_plus)
    velocity_x_minus = induced_velocity(blob, target_x_minus)
    velocity_y_plus = induced_velocity(blob, target_y_plus)
    velocity_y_minus = induced_velocity(blob, target_y_minus)

    du_dy = (velocity_y_plus[1] - velocity_y_minus[1]) / (2 * spacing)
    dv_dx = (velocity_x_plus[2] - velocity_x_minus[2]) / (2 * spacing)

    vorticity = dv_dx - du_dy

    # THEN

    @test isapprox(vorticity, expected_vorticity; rtol=1e-9)
end
