@testsnippet TestTree begin
    # GIVEN

    expected_dimension = 2
    expected_levels = 4
    expected_degree = 4
    expected_level_start = (1, 2, 6, 22)
    expected_level_lengths = (1, 4, 16, 64)
    expected_level_sizes = ((1, 1), (2, 2), (4, 4), (8, 8))
    expected_cells_per_axis = (1, 2, 4, 8)
    expected_cell_size = (1.0, 0.5, 0.25, 0.125)
    expected_chebyshev_nodes = (
        -0.9238795325112867, -0.3826834323650898, 0.3826834323650898, 0.9238795325112867
    )
    expected_weights = (
        0.3826834323650899, -0.9238795325112867, 0.9238795325112867, -0.3826834323650898
    )
    expected_parent_indices = [0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4]
    expected_child_indices = [
        (2, 3, 4, 5),
        (6, 7, 8, 9),
        (10, 11, 12, 13),
        (14, 15, 16, 17),
        (18, 19, 20, 21),
        (22, 23, 24, 25),
        (26, 27, 28, 29),
        (30, 31, 32, 33),
        (34, 35, 36, 37),
        (38, 39, 40, 41),
        (42, 43, 44, 45),
        (46, 47, 48, 49),
        (50, 51, 52, 53),
        (54, 55, 56, 57),
        (58, 59, 60, 61),
        (62, 63, 64, 65),
    ]

    # WHEN

    tree = build_tree(expected_dimension, expected_levels, expected_degree, expected_cell_size[1])
end

@testitem "Build 2D tree" setup = [TestTree] begin
    # THEN

    @test VEM.dimension(tree) == expected_dimension
    @test VEM.levels(tree) == expected_levels
    @test tree.level_start == expected_level_start
    @test tree.level_length == expected_level_lengths
    @test tree.level_size == expected_level_sizes
    @test tree.cells_per_axis == expected_cells_per_axis
    @test tree.cell_size == expected_cell_size
    @test all(tree.chebyshev_nodes .≈ expected_chebyshev_nodes)
    @test all(tree.chebyshev_weights .≈ expected_weights)
end

@testitem "Get storage index (in-range)" setup = [TestTree] begin
    # GIVEN

    levels = (1, 2, 3, 4)
    linear_indices = (1, 2, 5, 10)
    expected_storage_indices = (1, 3, 10, 31)

    # THEN

    for (level, linear_index, expected_storage_index) in
        zip(levels, linear_indices, expected_storage_indices)
        @test VEM.get_storage_index(tree, level, linear_index) == expected_storage_index
    end
end

@testitem "Get storage index (out-of-range)" setup = [TestTree] begin
    # GIVEN

    levels = (1, 1, 2, 2, 3, 3, 4, 4)
    linear_indices = (0, 2, 0, 5, 0, 17, 0, 65)

    # WHEN / THEN

    for (level, linear_index) in zip(levels, linear_indices)
        @test_throws ArgumentError VEM.get_storage_index(tree, level, linear_index)
    end
end

@testitem "Linear to Cartesian indices" begin
    # GIVEN

    linear_indices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
    cartesian_size = (4, 4)
    expected_cartesian_indices = [
        CartesianIndex(1, 1),
        CartesianIndex(2, 1),
        CartesianIndex(3, 1),
        CartesianIndex(4, 1),
        CartesianIndex(1, 2),
        CartesianIndex(2, 2),
        CartesianIndex(3, 2),
        CartesianIndex(4, 2),
        CartesianIndex(1, 3),
        CartesianIndex(2, 3),
        CartesianIndex(3, 3),
        CartesianIndex(4, 3),
        CartesianIndex(1, 4),
        CartesianIndex(2, 4),
        CartesianIndex(3, 4),
        CartesianIndex(4, 4),
    ]

    # WHEN / THEN

    for index in eachindex(linear_indices)
        @test VEM.linear_to_cartesian(linear_indices[index], cartesian_size) ==
            expected_cartesian_indices[index]
    end
end

@testitem "Cartesian to Linear indices" begin
    # GIVEN

    cartesian_indices = [
        CartesianIndex(1, 1),
        CartesianIndex(2, 1),
        CartesianIndex(3, 1),
        CartesianIndex(4, 1),
        CartesianIndex(1, 2),
        CartesianIndex(2, 2),
        CartesianIndex(3, 2),
        CartesianIndex(4, 2),
        CartesianIndex(1, 3),
        CartesianIndex(2, 3),
        CartesianIndex(3, 3),
        CartesianIndex(4, 3),
        CartesianIndex(1, 4),
        CartesianIndex(2, 4),
        CartesianIndex(3, 4),
        CartesianIndex(4, 4),
    ]
    cartesian_size = (4, 4)
    expected_linear_indices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]

    # WHEN / THEN

    for index in eachindex(cartesian_indices)
        @test VEM.cartesian_to_linear(cartesian_indices[index], cartesian_size) ==
            expected_linear_indices[index]
    end
end

@testitem "Get parent index (in-range)" setup = [TestTree] begin
    # GIVEN

    levels = (2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)
    linear_indices = (1, 4, 1, 6, 11, 16, 1, 10, 19, 28, 37, 46, 55, 64)
    expected_parent_indices = (1, 1, 1, 1, 4, 4, 1, 1, 6, 6, 11, 11, 16, 16)

    # WHEN / THEN

    for (level, linear_index, expected_parent_index) in
        zip(levels, linear_indices, expected_parent_indices)
        @test VEM.get_parent_index(tree, level, linear_index) == expected_parent_index
    end
end

@testitem "Get parent index (out-of-range)" setup = [TestTree] begin
    # GIVEN

    levels = (1, 2, 2, 3, 3, 4, 4)
    linear_indices = (1, 0, 5, 0, 17, 0, 65)

    # WHEN / THEN

    for (level, linear_index) in zip(levels, linear_indices)
        @test_throws ArgumentError VEM.get_parent_index(tree, level, linear_index)
    end
end

@testitem "Get child indices (in-range)" setup = [TestTree] begin
    # GIVEN

    levels = (1, 2, 3)
    linear_indices = (1, 2, 5)
    expected_child_indices = ((1, 2, 3, 4), (3, 4, 7, 8), (17, 18, 25, 26))

    # WHEN / THEN

    for (level, linear_index, expected_child_index) in
        zip(levels, linear_indices, expected_child_indices)
        @test VEM.get_child_indices(tree, level, linear_index) == expected_child_index
    end
end

@testitem "Get child indices (out-of-range)" setup = [TestTree] begin
    # THEN

    @test_throws ArgumentError VEM.get_child_indices(tree, 4, 10) == (35, 36, 43, 44)
end

@testitem "Get indices associated with points" setup = [TestTree] begin
    # GIVEN

    points = [
        VEM.SA.SVector{2,Float64}(0.1, 0.1),
        VEM.SA.SVector{2,Float64}(0.6, 0.1),
        VEM.SA.SVector{2,Float64}(0.1, 0.6),
        VEM.SA.SVector{2,Float64}(0.6, 0.6),
        VEM.SA.SVector{2,Float64}(0.3, 0.3),
        VEM.SA.SVector{2,Float64}(0.8, 0.3),
        VEM.SA.SVector{2,Float64}(0.3, 0.8),
        VEM.SA.SVector{2,Float64}(0.8, 0.8),
    ]
    expected_linear_indexes = [1, 5, 33, 37, 19, 23, 51, 55]

    # WHEN / THEN

    for (index, point) in enumerate(points)
        @test VEM.point_to_leaf_index(tree, point) == expected_linear_indexes[index]
    end
end

@testitem "Get roots degree 4 Chebyshev monomial in [-1, 1]" begin
    # GIVEN

    degree = 4
    x_min = -1.0
    x_max = 1.0

    expected_roots = (
        -0.9238795325112867, -0.3826834323650898, 0.3826834323650898, 0.9238795325112867
    )

    # WHEN

    roots = VEM.chebyshev_roots(degree, x_min, x_max)

    # THEN

    @test all(roots .≈ expected_roots)
end

@testitem "Get roots degree 4 Chebyshev monomial in [0, 2]" begin
    # GIVEN

    degree = 4
    x_min = 0.0
    x_max = 2.0

    expected_roots = (
        0.07612046748871326, 0.6173165676349102, 1.3826834323650898, 1.9238795325112867
    )

    # WHEN

    roots = VEM.chebyshev_roots(degree, x_min, x_max)

    # THEN

    @test all(roots .≈ expected_roots)
end

@testitem "Get roots degree 4 Chebyshev monomial in [3, 4]" begin
    # GIVEN

    degree = 4
    x_min = 3.0
    x_max = 4.0

    expected_roots = (3.0380602337443565, 3.308658283817455, 3.691341716182545, 3.9619397662556435)

    # WHEN

    roots = VEM.chebyshev_roots(degree, x_min, x_max)

    # THEN

    @test all(roots .≈ expected_roots)
end