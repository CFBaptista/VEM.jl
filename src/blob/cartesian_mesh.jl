"""
    CartesianMesh{Dimension,Scalar<:AbstractFloat}(cells_per_axis::NTuple{Dimension,Int}, spacing::Scalar)

    A Cartesian mesh for vortex blob methods.

# Argumentss
- `cells_per_axis: The number of cells along each axis.
- `spacing`: The spacing between nodes in the mesh.
"""
struct CartesianMesh{Dimension,Scalar<:AbstractFloat}
    cells_per_axis::NTuple{Dimension,Int}
    spacing::Scalar
end

"""
    mesh_dimension(::CartesianMesh)

Get the dimension of the `CartesianMesh`.

# Arguments
- `::CartesianMesh`: The Cartesian mesh.

# Returns
The dimension of the Cartesian mesh.
"""
mesh_dimension(::CartesianMesh{Dimension}) where {Dimension} = Dimension

"""
    mesh_scalar(::CartesianMesh)

Get the scalar type of the `CartesianMesh`.

# Arguments
- `::CartesianMesh`: The Cartesian mesh.

# Returns
The scalar type of the Cartesian mesh.
"""
mesh_scalar(::CartesianMesh{Dimension,Scalar}) where {Dimension,Scalar} = Scalar

"""
    cells_per_axis(mesh::CartesianMesh)

Get the number of cells per axis in the `mesh`.

# Arguments
- `mesh`: The Cartesian mesh.

# Returns
The number of cells per axis in the Cartesian mesh.
"""
cells_per_axis(mesh::CartesianMesh) = mesh.cells_per_axis

"""
    nodes_per_axis(::CartesianMesh)

Get the number of nodes per axis in the `mesh`.

# Arguments
- `mesh`: The Cartesian mesh.

# Returns
The number of nodes per axis in the Cartesian mesh.
"""
nodes_per_axis(mesh::CartesianMesh) = mesh.cells_per_axis .+ 1

"""
    node_spacing(::CartesianMesh)

Get the spacing between nodes in the `mesh`.

# Arguments
- `mesh`: The Cartesian mesh.

# Returns
The spacing between nodes in the Cartesian mesh.
"""
node_spacing(mesh::CartesianMesh) = mesh.spacing

"""
    mesh_nodes(mesh)

Get the nodes of the `mesh`.

# Arguments
- `mesh`: The Cartesian mesh.

# Returns
The nodes of the Cartesian mesh as a matrix of static vectors.
"""
function mesh_nodes(mesh::CartesianMesh)
    dimension = mesh_dimension(mesh)
    scalar = mesh_scalar(mesh)
    size = nodes_per_axis(mesh)
    spacing = node_spacing(mesh)

    nodes = zeros(SA.SVector{dimension,scalar}, size)

    Threads.@threads for index in CartesianIndices(size)
        @inbounds nodes[index] = (index.I .- 1) .* spacing
    end

    return nodes
end
