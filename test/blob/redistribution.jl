@testsnippet TestRedistribution begin
    # GIVEN

    struct Simple <: VEM.AbstractRedistributionKernel end
    VEM.redistribution_weight(::Simple, r) = r <= 2 ? 1.0 : 0.0
    VEM.support_radius(::Simple) = 2
end

@testsnippet TestRedistributionPerfectOverlap begin
    # GIVEN

    mesh = CartesianMesh((5, 5), 0.2)
    kernel = Simple()

    circulation = 0.6530376028766707
    radius = node_spacing(mesh)

    absolute_tolerance = 1e-15
end

@testitem "Blob outside of redistribution mesh throws ArgumentError" setup = [
    TestRedistribution, TestRedistributionPerfectOverlap
] begin
    # GIVEN

    centers = [[-1.0, 0.5], [1.5, 0.5], [0.5, -1.0], [0.5, 1.5]]

    # WHEN / THEN

    for center in centers
        blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]
        @test_throws ArgumentError interpolate_circulation(blobs, mesh, kernel)
    end
end

@testitem "Number of redistributed blobs equals number of nodes in mesh" setup = [
    TestRedistribution, TestRedistributionPerfectOverlap
] begin
    # GIVEN

    center = [0.5, 0.5]

    blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]

    # WHEN

    redistributed_blobs = interpolate_circulation(blobs, mesh, kernel)

    # THEN

    @test size(redistributed_blobs) == nodes_per_axis(mesh)
end

@testitem "Number of non-zero redistributed blobs equals 16 for source blob far from mesh boundaries" setup = [
    TestRedistribution, TestRedistributionPerfectOverlap
] begin
    # GIVEN

    center = [0.5, 0.5]

    blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]

    # WHEN

    redistributed_blobs = interpolate_circulation(blobs, mesh, kernel)

    # THEN

    @test sum(x -> x != 0, redistributed_blobs) == 16
end

@testitem "Number of non-zero redistributed blobs equals 12 for source blob near a mesh edge" setup = [
    TestRedistribution, TestRedistributionPerfectOverlap
] begin
    # GIVEN

    centers = [[0.1, 0.5], [0.9, 0.5], [0.5, 0.1], [0.5, 0.9]]

    # WHEN / THEN

    for center in centers
        blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]
        redistributed_blobs = interpolate_circulation(blobs, mesh, kernel)

        @test sum(x -> x != 0, redistributed_blobs) == 12
    end
end

@testitem "Number of non-zero redistributed blobs equals 9 for source blob near a mesh corner" setup = [
    TestRedistribution, TestRedistributionPerfectOverlap
] begin
    # GIVEN

    centers = [[0.1, 0.1], [0.9, 0.1], [0.9, 0.1], [0.9, 0.9]]

    # WHEN / THEN

    for center in centers
        blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]
        redistributed_blobs = interpolate_circulation(blobs, mesh, kernel)

        @test sum(x -> x != 0, redistributed_blobs) == 9
    end
end

@testsnippet TestRedistributionOverResolved begin
    # GIVEN

    mesh = CartesianMesh((7, 7), 1 / 7)
    kernel = Simple()

    overlap_ratio = 1.5

    circulation = 0.6530376028766707
    radius = overlap_ratio * node_spacing(mesh)

    absolute_tolerance = 1e-15
end

@testitem "Number of non-zero redistributed blobs equals 36 for source blob far from mesh boundaries" setup = [
    TestRedistribution, TestRedistributionOverResolved
] begin
    # GIVEN

    center = [0.5, 0.5]

    blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]

    # WHEN

    redistributed_blobs = interpolate_circulation(blobs, mesh, kernel)

    # THEN

    @test sum(x -> x != 0, redistributed_blobs) == 36
end

@testitem "Number of non-zero redistributed blobs equals 24 for source blob near a mesh edge" setup = [
    TestRedistribution, TestRedistributionOverResolved
] begin
    # GIVEN

    centers = [[1 / 14, 0.5], [13 / 14, 0.5], [0.5, 1 / 14], [0.5, 13 / 14]]

    # WHEN / THEN

    for center in centers
        blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]
        redistributed_blobs = interpolate_circulation(blobs, mesh, kernel)

        @test sum(x -> x != 0, redistributed_blobs) == 24
    end
end

@testitem "Number of non-zero redistributed blobs equals 16 for source blob near a mesh corner" setup = [
    TestRedistribution, TestRedistributionOverResolved
] begin
    # GIVEN

    centers = [[0.1, 0.1], [0.9, 0.1], [0.9, 0.1], [0.9, 0.9]]

    # WHEN / THEN

    for center in centers
        blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]
        redistributed_blobs = interpolate_circulation(blobs, mesh, kernel)

        @test sum(x -> x != 0, redistributed_blobs) == 16
    end
end

@testsnippet TestRedistributionUnderResolved begin
    # GIVEN

    mesh = CartesianMesh((7, 7), 1 / 7)
    kernel = Simple()

    overlap_ratio = 0.5

    circulation = 0.6530376028766707
    radius = overlap_ratio * node_spacing(mesh)

    absolute_tolerance = 1e-15
end

@testitem "Number of non-zero redistributed blobs equals 4 for source blob far from mesh boundaries" setup = [
    TestRedistribution, TestRedistributionUnderResolved
] begin
    # GIVEN

    center = [0.5, 0.5]

    blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]

    # WHEN

    redistributed_blobs = interpolate_circulation(blobs, mesh, kernel)

    # THEN

    @test sum(x -> x != 0, redistributed_blobs) == 4
end

@testitem "Number of non-zero redistributed blobs equals 4 for source blob near a mesh edge" setup = [
    TestRedistribution, TestRedistributionUnderResolved
] begin
    # GIVEN

    centers = [[1 / 14, 0.5], [13 / 14, 0.5], [0.5, 1 / 14], [0.5, 13 / 14]]

    # WHEN / THEN

    for center in centers
        blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]
        redistributed_blobs = interpolate_circulation(blobs, mesh, kernel)

        @test sum(x -> x != 0, redistributed_blobs) == 4
    end
end

@testitem "Number of non-zero redistributed blobs equals 4 for source blob near a mesh corner" setup = [
    TestRedistribution, TestRedistributionUnderResolved
] begin
    # GIVEN

    centers = [[0.1, 0.1], [0.9, 0.1], [0.9, 0.1], [0.9, 0.9]]

    # WHEN / THEN

    for center in centers
        blobs = [GaussianVortexBlob{2,Float}(circulation, center, radius)]
        redistributed_blobs = interpolate_circulation(blobs, mesh, kernel)

        @test sum(x -> x != 0, redistributed_blobs) == 4
    end
end
