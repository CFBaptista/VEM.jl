@testsnippet TestCartesianMesh begin
    # GIVEN

    mesh = CartesianMesh((5, 5), 0.1)

    expected_dimension = 2
    expected_scalar = Float
    expected_cells_per_axis = (5, 5)
    expected_nodes_per_axis = (6, 6)
    expected_node_spacing = 0.1

    expected_mesh_nodes = [
        VEM.SA.SVector{expected_dimension,expected_scalar}(x, y) for x in 0:0.1:0.5, y in 0:0.1:0.5
    ]
end

@testitem "Get CartesianMesh dimension (2D)" setup = [TestCartesianMesh] begin
    # WHEN

    dimension = mesh_dimension(mesh)

    # THEN

    @test dimension == expected_dimension
end

@testitem "Get CartesianMesh scalar" setup = [TestCartesianMesh] begin
    # WHEN

    scalar = mesh_scalar(mesh)

    # THEN

    @test scalar == expected_scalar
end

@testitem "Get CartesianMesh cells per axis" setup = [TestCartesianMesh] begin
    # WHEN

    number_per_axis = cells_per_axis(mesh)

    # THEN

    @test number_per_axis == expected_cells_per_axis
end

@testitem "Get CartesianMesh nodes per axis" setup = [TestCartesianMesh] begin
    # WHEN

    number_per_axis = nodes_per_axis(mesh)

    # THEN

    @test number_per_axis == expected_nodes_per_axis
end

@testitem "Get CartesianMesh node spacing" setup = [TestCartesianMesh] begin
    # WHEN

    spacing = node_spacing(mesh)

    # THEN

    @test spacing == expected_node_spacing
end

@testitem "Get CartesianMesh nodes" setup = [TestCartesianMesh] begin
    # WHEN

    nodes = mesh_nodes(mesh)

    # THEN

    @test isapprox(nodes, expected_mesh_nodes)
end
