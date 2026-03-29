@testsnippet TestPopulationControl begin
    using VEM

    struct Blob <: AbstractVortexBlob{2,Float64}
        circulation::Float64
    end
end

@testitem "Population control with positive blobs" setup = [TestPopulationControl] begin
    # GIVEN

    blobs = [Blob(i) for i in 1:10]
    tolerance = 0.5

    expected_remaining_blob = 4
    expected_removed_circulation = 21.0

    # WHEN

    removed_circulation = population_control!(blobs, tolerance)

    #THEN

    @test length(blobs) == expected_remaining_blob
    @test removed_circulation ≈ expected_removed_circulation
end

@testitem "Population control with negative blobs" setup = [TestPopulationControl] begin
    # GIVEN

    blobs = [Blob(-i) for i in 1:10]
    tolerance = 0.5

    expected_remaining_blob = 4
    expected_removed_circulation = -21.0

    # WHEN

    removed_circulation = population_control!(blobs, tolerance)

    #THEN

    @test length(blobs) == expected_remaining_blob
    @test removed_circulation ≈ expected_removed_circulation
end

@testitem "Population control with mixed blobs" setup = [TestPopulationControl] begin
    # GIVEN

    blobs = [Blob((-1)^i * i) for i in 1:10]
    tolerance = 0.5

    expected_remaining_blob = 4
    expected_removed_circulation = 3.0

    # WHEN

    removed_circulation = population_control!(blobs, tolerance)

    #THEN

    @test length(blobs) == expected_remaining_blob
    @test removed_circulation ≈ expected_removed_circulation
end

@testitem "Population control with zero circulation blobs" setup = [TestPopulationControl] begin
    # GIVEN

    blobs = [Blob(0.0) for i in 1:10]
    tolerance = 0.5

    expected_remaining_blob = 0
    expected_removed_circulation = 0.0

    # WHEN

    removed_circulation = population_control!(blobs, tolerance)

    #THEN

    @test length(blobs) == expected_remaining_blob
    @test removed_circulation ≈ expected_removed_circulation
end
