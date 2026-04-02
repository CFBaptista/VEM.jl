@testsnippet TestCartesianMesh2D begin
    # GIVEN

    mesh = CartesianMesh(zero(VEM.SA.SVector{2,Float64}), (5, 5), 0.1)

    expected_dimension = 2
    expected_scalar = Float64
    expected_cells_per_axis = (5, 5)
    expected_nodes_per_axis = (6, 6)
    expected_node_spacing = 0.1
    expected_mesh_bounds = ((0.0, 0.5), (0.0, 0.5))

    expected_mesh_nodes = [
        VEM.SA.SVector{expected_dimension,expected_scalar}(x, y) for x in 0:0.1:0.5, y in 0:0.1:0.5
    ]
end

@testitem "Get 2D Cartesian mesh dimension" setup = [TestCartesianMesh2D] begin
    # WHEN

    dimension = mesh_dimension(mesh)

    # THEN

    @test dimension == expected_dimension
end

@testitem "Get 2D Cartesian mesh scalar" setup = [TestCartesianMesh2D] begin
    # WHEN

    scalar = mesh_scalar(mesh)

    # THEN

    @test scalar == expected_scalar
end

@testitem "Get 2D Cartesian mesh cells per axis" setup = [TestCartesianMesh2D] begin
    # WHEN

    number_per_axis = cells_per_axis(mesh)

    # THEN

    @test number_per_axis == expected_cells_per_axis
end

@testitem "Get 2D Cartesian mesh nodes per axis" setup = [TestCartesianMesh2D] begin
    # WHEN

    number_per_axis = nodes_per_axis(mesh)

    # THEN

    @test number_per_axis == expected_nodes_per_axis
end

@testitem "Get 2D Cartesian mesh node spacing" setup = [TestCartesianMesh2D] begin
    # WHEN

    spacing = node_spacing(mesh)

    # THEN

    @test spacing == expected_node_spacing
end

@testitem "Get 2D Cartesian mesh bounds" setup = [TestCartesianMesh2D] begin
    # WHEN

    bounds = mesh_bounds(mesh)

    # THEN

    @test bounds == expected_mesh_bounds
end

@testitem "Get 2D Cartesian mesh nodes" setup = [TestCartesianMesh2D] begin
    # WHEN

    nodes = mesh_nodes(mesh)

    # THEN

    @test isapprox(nodes, expected_mesh_nodes)
end

@testsnippet TestCartesianMesh3D begin
    # GIVEN

    mesh = CartesianMesh(zero(VEM.SA.SVector{3,Float64}), (5, 5, 5), 0.1)

    expected_dimension = 3
    expected_scalar = Float64
    expected_cells_per_axis = (5, 5, 5)
    expected_nodes_per_axis = (6, 6, 6)
    expected_node_spacing = 0.1
    expected_mesh_bounds = ((0.0, 0.5), (0.0, 0.5), (0.0, 0.5))

    expected_mesh_nodes = [
        VEM.SA.SVector{expected_dimension,expected_scalar}(x, y, z) for x in 0:0.1:0.5,
        y in 0:0.1:0.5, z in 0:0.1:0.5
    ]
end

@testitem "Get 3D Cartesian mesh dimension" setup = [TestCartesianMesh3D] begin
    # WHEN

    dimension = mesh_dimension(mesh)

    # THEN

    @test dimension == expected_dimension
end

@testitem "Get 3D Cartesian mesh scalar" setup = [TestCartesianMesh3D] begin
    # WHEN

    scalar = mesh_scalar(mesh)

    # THEN

    @test scalar == expected_scalar
end

@testitem "Get 3D Cartesian mesh cells per axis" setup = [TestCartesianMesh3D] begin
    # WHEN

    number_per_axis = cells_per_axis(mesh)

    # THEN

    @test number_per_axis == expected_cells_per_axis
end

@testitem "Get 3D Cartesian mesh nodes per axis" setup = [TestCartesianMesh3D] begin
    # WHEN

    number_per_axis = nodes_per_axis(mesh)

    # THEN

    @test number_per_axis == expected_nodes_per_axis
end

@testitem "Get 3D Cartesian mesh node spacing" setup = [TestCartesianMesh3D] begin
    # WHEN

    spacing = node_spacing(mesh)

    # THEN

    @test spacing == expected_node_spacing
end

@testitem "Get 3D Cartesian mesh bounds" setup = [TestCartesianMesh3D] begin
    # WHEN

    bounds = mesh_bounds(mesh)

    # THEN

    @test bounds == expected_mesh_bounds
end

@testitem "Get 3D Cartesian mesh nodes" setup = [TestCartesianMesh3D] begin
    # WHEN

    nodes = mesh_nodes(mesh)

    # THEN

    @test isapprox(nodes, expected_mesh_nodes)
end
