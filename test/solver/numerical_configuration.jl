@testitem "Construct NumericalConfiguration with default values" begin
    # GIVEN

    expected_mesh_spacing = 0.1
    expected_advection_time_scheme = VEM.ODE.RK4()
    expected_diffusion_time_scheme = VEM.ODE.RK4()
    expected_redistribution_kernel = M4Prime()
    expected_overlap_ratio = 1.0
    expected_population_control_threshold = 1e-6

    # WHEN

    numerical_configuration = NumericalConfiguration(expected_mesh_spacing)

    # THEN

    @test numerical_configuration.mesh_spacing == expected_mesh_spacing
    @test numerical_configuration.advection_time_scheme == expected_advection_time_scheme
    @test numerical_configuration.diffusion_time_scheme == expected_diffusion_time_scheme
    @test numerical_configuration.redistribution_kernel == expected_redistribution_kernel
    @test numerical_configuration.overlap_ratio == expected_overlap_ratio
    @test numerical_configuration.population_control_threshold ==
        expected_population_control_threshold
end

@testitem "Construct NumericalConfiguration with custom values" begin
    # GIVEN

    struct NewKernel <: AbstractRedistributionKernel end

    expected_mesh_spacing = 0.05
    expected_advection_time_scheme = VEM.ODE.Euler()
    expected_diffusion_time_scheme = VEM.ODE.Euler()
    expected_redistribution_kernel = NewKernel()
    expected_overlap_ratio = 0.5
    expected_population_control_threshold = 1e-5

    # WHEN

    numerical_configuration = NumericalConfiguration(
        expected_mesh_spacing;
        advection_time_scheme=expected_advection_time_scheme,
        diffusion_time_scheme=expected_diffusion_time_scheme,
        redistribution_kernel=expected_redistribution_kernel,
        overlap_ratio=expected_overlap_ratio,
        population_control_threshold=expected_population_control_threshold,
    )

    # THEN

    @test numerical_configuration.mesh_spacing == expected_mesh_spacing
    @test numerical_configuration.advection_time_scheme == expected_advection_time_scheme
    @test numerical_configuration.diffusion_time_scheme == expected_diffusion_time_scheme
    @test numerical_configuration.redistribution_kernel == expected_redistribution_kernel
    @test numerical_configuration.overlap_ratio == expected_overlap_ratio
    @test numerical_configuration.population_control_threshold ==
        expected_population_control_threshold
end

@testitem "Construct NumericalConfiguration with invalid mesh spacing" begin
    # GIVEN

    invalid_mesh_spacing = -0.1

    # WHEN / THEN

    @test_throws ArgumentError NumericalConfiguration(invalid_mesh_spacing)
end

@testitem "Construct NumericalConfiguration with invalid overlap ratio" begin
    # GIVEN

    expected_mesh_spacing = 0.1
    invalid_overlap_ratio = -1.0

    # WHEN / THEN

    @test_throws ArgumentError NumericalConfiguration(
        expected_mesh_spacing; overlap_ratio=invalid_overlap_ratio
    )
end

@testitem "Construct NumericalConfiguration with invalid population control threshold" begin
    # GIVEN

    expected_mesh_spacing = 0.1
    invalid_population_control_threshold = -1e-6

    # WHEN / THEN

    @test_throws ArgumentError NumericalConfiguration(
        expected_mesh_spacing; population_control_threshold=invalid_population_control_threshold
    )
end
