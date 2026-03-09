@testsnippet TestM4PrimeKernel begin
    # GIVEN

    kernel = M4Prime()
    expected_support_radius = 2
end

@testitem "Get M4' support radius" setup = [TestM4PrimeKernel] begin
    # WHEN

    radius = support_radius(kernel)

    # THEN

    @test radius == expected_support_radius
end

@testitem "Compute M4' redistribution weight" setup = [TestM4PrimeKernel] begin
    # GIVEN

    distances = 0.0:0.5:2.5
    expected_weights = [1.0, 0.5625, 0.0, -0.0625, 0.0, 0.0]

    # WHEN

    weights = [redistribution_weight(kernel, x) for x in distances]

    # THEN

    @test isapprox(weights, expected_weights)
end
