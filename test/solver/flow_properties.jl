@testitem "Construct FlowProperties" begin
    # GIVEN

    expected_density = 1.0
    expected_kinematic_viscosity = 1.0e-6
    expected_freestream_velocity = VEM.SA.SVector{3,Float64}(10.0, 0.0, 0.0)

    # WHEN

    flow_properties = FlowProperties{3,Float64}(
        expected_density, expected_kinematic_viscosity, expected_freestream_velocity
    )

    # THEN

    @test flow_properties.density == expected_density
    @test flow_properties.kinematic_viscosity == expected_kinematic_viscosity
    @test flow_properties.freestream_velocity == expected_freestream_velocity
end

@testitem "Construct FlowProperties with invalid dimension" begin
    # GIVEN

    density = 1.0
    kinematic_viscosity = 1.0e-6
    freestream_velocity = VEM.SA.SVector{4,Float64}(10.0, 0.0, 0.0, 0.0)

    # THEN

    @test_throws ArgumentError FlowProperties{4,Float64}(
        density, kinematic_viscosity, freestream_velocity
    )
end

@testitem "Construct FlowProperties with non-positive density" begin
    # GIVEN

    density = -1.0
    kinematic_viscosity = 1.0e-6
    freestream_velocity = VEM.SA.SVector{2,Float64}(10.0, 0.0)

    # THEN

    @test_throws ArgumentError FlowProperties{2,Float64}(
        density, kinematic_viscosity, freestream_velocity
    )
end

@testitem "Construct FlowProperties with non-positive kinematic viscosity" begin
    # GIVEN

    density = 1.0
    kinematic_viscosity = -1.0e-6
    freestream_velocity = VEM.SA.SVector{2,Float64}(10.0, 0.0)

    # THEN

    @test_throws ArgumentError FlowProperties{2,Float64}(
        density, kinematic_viscosity, freestream_velocity
    )
end
