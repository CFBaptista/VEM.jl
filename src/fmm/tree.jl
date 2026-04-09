"""
    Tree{Dimension,Levels,Degree,Children,Float}

A data structure representing the hierarchical tree used in the Fast Multipole Method (FMM).

# Type Parameters
- `Dimension`: The spatial dimension of the problem (e.g., 2 for 2D, 3 for 3D).
- `Levels`: The total number of levels in the tree, including the root level.
- `Degree`: The degree of the Chebyshev interpolation used for the multipole expansions.
- `Children`: The number of children each cell has (must be equal to `2^Dimension`).
- `Float`: The floating-point type used for calculations (e.g., `Float64`).

# Fields
- `level_length}`: The number of cells at each level of the tree.
- `level_size`: The size of the grid at each level, represented as a tuple of integers for each dimension.
- `cells_per_axis`: The number of cells along a single axis at each level.
- `cell_size`: The physical size of each cell at each level.
- `level_start`: The starting index in the storage arrays for each level.
- `parent_index`: A vector mapping each cell's storage index to its parent cell's storage index.
- `child_indices`: A vector mapping each cell's storage index to a tuple of its children's storage indices.
- `interaction_indices`: A vector mapping each cell's storage index to a tuple of storage indices for its interaction list.
- `chebyshev_nodes`: The Chebyshev (root) nodes used for interpolation.
- `chebyshev_weights`: The barycentric weights associated with the Chebyshev nodes.
"""
struct Tree{Dimension,Levels,Degree,Children,Float<:AbstractFloat}
    level_length::NTuple{Levels,Int}
    level_size::NTuple{Levels,NTuple{Dimension,Int}}
    cells_per_axis::NTuple{Levels,Int}
    cell_size::NTuple{Levels,Float}
    level_start::NTuple{Levels,Int}
    parent_index::Vector{Int}
    child_indices::Vector{NTuple{Children,Int}}
    interaction_indices::Vector{Tuple{Int,Vararg{Int}}}
    chebyshev_nodes::NTuple{Degree,Float}
    chebyshev_weights::NTuple{Degree,Float}

    function Tree{Dimension,Levels,Degree,Children,Float}(
        level_length,
        level_size,
        cells_per_axis,
        cell_size,
        level_start,
        parent_index,
        child_indices,
        interaction_indices,
        chebyshev_nodes,
        chebyshev_weights,
    ) where {Dimension,Levels,Degree,Children,Float<:AbstractFloat}
        Dimension > 0 || throw(ArgumentError("Dimension must be positive."))
        Levels > 1 || throw(ArgumentError("Levels must be greater than 1."))
        Degree > 0 || throw(ArgumentError("Degree must be positive."))
        Children == 2^Dimension || throw(ArgumentError("Children must be equal to 2^Dimension."))

        return new{Dimension,Levels,Degree,Children,Float}(
            level_length,
            level_size,
            cells_per_axis,
            cell_size,
            level_start,
            parent_index,
            child_indices,
            interaction_indices,
            chebyshev_nodes,
            chebyshev_weights,
        )
    end
end

dimension(::Type{<:Tree{Dimension}}) where {Dimension} = Dimension
dimension(tree::Tree) = dimension(typeof(tree))

levels(::Type{<:Tree{Dimension,Levels,Float}}) where {Dimension,Levels,Float} = Levels
levels(tree::Tree) = levels(typeof(tree))

"""
    build_tree(dimension::Int, levels::Int, degree::Int, domain_length::AbstractFloat)

Constructs a hierarchical tree structure for the Fast Multipole Method (FMM) based on the specified parameters.

# Arguments
- `dimension`: The spatial dimension of the tree (e.g., 2 for 2D, 3 for 3D).
- `levels`: The total number of levels in the tree, including the root level.
- `degree`: The degree of Chebyshev polynomials used for the multipole expansions.
- `domain_length`: The physical length of the domain along each axis (assumed to be the same for all axes).
"""
function build_tree(dimension::Int, levels::Int, degree::Int, domain_length::AbstractFloat)
    Float = typeof(domain_length)

    level_start = zeros(Int, levels)
    level_start[1] = 1

    level_length = zeros(Int, levels)
    level_length[1] = 1

    level_size = [Tuple(0 for _ in 1:dimension) for _ in 1:levels]
    level_size[1] = Tuple(1 for _ in 1:dimension)

    cells_per_axis = zeros(Int, levels)
    cells_per_axis[1] = 1

    cell_size = zeros(Float, levels)
    cell_size[1] = domain_length

    chebyshev_nodes = chebyshev_roots(degree, -one(Float), one(Float))

    chebyshev_weights_ = chebyshev_weights(degree, Float)

    number_of_children = 2^dimension

    divisor = 1

    for level in 2:levels
        divisor *= 2

        level_length[level] = level_length[level - 1] * number_of_children
        cells_per_axis[level] = cells_per_axis[level - 1] * 2
        level_size[level] = Tuple(cells_per_axis[level] for _ in 1:dimension)
        level_start[level] = level_start[level - 1] + level_length[level - 1]
        cell_size[level] = cell_size[1] / divisor
    end

    tree = Tree{dimension,levels,degree,number_of_children,Float}(
        Tuple(level_length),
        Tuple(level_size),
        Tuple(cells_per_axis),
        Tuple(cell_size),
        Tuple(level_start),
        zeros(Int, sum(level_length)),
        fill(Tuple(0 for _ in 1:number_of_children), sum(level_length[1:(end - 1)])),
        fill(Tuple(0), sum(level_length)),
        chebyshev_nodes,
        chebyshev_weights_,
    )

    for level in 1:levels
        for cell in 1:level_length[level]
            storage_index = get_storage_index(tree, level, cell)

            if level > 1
                parent_index = get_parent_index(tree, level, cell)
                tree.parent_index[storage_index] = get_storage_index(tree, level - 1, parent_index)
            end

            if level > 2
                interaction_indices = get_interaction_indices(tree, level, cell)
                tree.interaction_indices[storage_index] = interaction_indices
            end

            if level < levels
                child_indices = get_child_indices(tree, level, cell)
                tree.child_indices[storage_index] = Tuple(
                    get_storage_index(tree, level + 1, child) for child in child_indices
                )
            end
        end
    end

    return tree
end

function get_storage_index(tree::Tree, level::Int, linear_index::Int)
    1 <= linear_index <= tree.level_length[level] ||
        throw(ArgumentError("Index out of bounds for the specified level."))
    return tree.level_start[level] + linear_index - 1
end

function get_parent_index(tree::Tree, level::Int, linear_index::Int)
    level > 1 || throw(ArgumentError("Level must be greater than 1 to have a parent."))
    1 <= linear_index <= tree.level_length[level] ||
        throw(ArgumentError("Index out of bounds for the specified level."))
    cartesian_index = linear_to_cartesian(
        linear_index, Tuple(tree.cells_per_axis[level] for _ in 1:dimension(tree))
    )
    parent_cartesian_index = CartesianIndex(Tuple(cld(x, 2) for x in Tuple(cartesian_index)))
    parent_linear_index = cartesian_to_linear(
        parent_cartesian_index, Tuple(tree.cells_per_axis[level - 1] for _ in 1:dimension(tree))
    )

    return parent_linear_index
end

function get_child_indices(tree::Tree, level::Int, linear_index::Int)
    level < levels(tree) ||
        throw(ArgumentError("Level must be less than the total number of levels to have children."))
    cartesian_index = linear_to_cartesian(
        linear_index, Tuple(tree.cells_per_axis[level] for _ in 1:dimension(tree))
    )
    reference_child_cartesian_index = CartesianIndex(Tuple(x * 2 for x in Tuple(cartesian_index)))
    child_level_size = Tuple(tree.cells_per_axis[level + 1] for _ in 1:dimension(tree))
    child_indices = collect_children(reference_child_cartesian_index, child_level_size)
    return child_indices
end

function collect_children(reference_cartesian_index::CartesianIndex{2}, level_size::NTuple{2,Int})
    x, y = Tuple(reference_cartesian_index)
    indices = (
        cartesian_to_linear(CartesianIndex(x - 1, y - 1), level_size),
        cartesian_to_linear(CartesianIndex(x, y - 1), level_size),
        cartesian_to_linear(CartesianIndex(x - 1, y), level_size),
        cartesian_to_linear(reference_cartesian_index, level_size),
    )
    return indices
end

function collect_children(reference_cartesian_index::CartesianIndex{3}, level_size::NTuple{3,Int})
    x, y, z = Tuple(reference_cartesian_index)
    indices = (
        cartesian_to_linear(CartesianIndex(x - 1, y - 1, z - 1), level_size),
        cartesian_to_linear(CartesianIndex(x, y - 1, z - 1), level_size),
        cartesian_to_linear(CartesianIndex(x - 1, y, z - 1), level_size),
        cartesian_to_linear(CartesianIndex(x, y, z - 1), level_size),
        cartesian_to_linear(CartesianIndex(x - 1, y - 1, z), level_size),
        cartesian_to_linear(CartesianIndex(x, y - 1, z), level_size),
        cartesian_to_linear(CartesianIndex(x - 1, y, z), level_size),
        cartesian_to_linear(reference_cartesian_index, level_size),
    )
    return indices
end

function get_neighbor_indices(tree::Tree, level::Int, linear_index::Int)
    cartesian_index = linear_to_cartesian(linear_index, tree.level_size[level])
    neighbor_cartesian_indices = cartesian_neighbor_indices(cartesian_index, tree.level_size[level])
    neighbor_linear_indices = Tuple(
        cartesian_to_linear(index, tree.level_size[level]) for index in neighbor_cartesian_indices
    )
    return neighbor_linear_indices
end

function cartesian_neighbor_indices(cartesian_index::CartesianIndex, cartesian_size::NTuple)
    lower_bound = CartesianIndex((max(1, i - 1) for i in Tuple(cartesian_index))...)
    upper_bound = CartesianIndex(
        (min(s, i + 1) for (i, s) in zip(Tuple(cartesian_index), cartesian_size))...
    )
    return lower_bound:upper_bound
end

function get_interaction_indices(tree::Tree, level::Int, linear_index::Int)
    parent_index = get_parent_index(tree, level, linear_index)
    parent_neighbor_indices = get_neighbor_indices(tree, level - 1, parent_index)
    child_indices = Tuple(
        get_child_indices(tree, level - 1, index) for index in parent_neighbor_indices
    )
    child_indices = Tuple(Iterators.flatten(child_indices))
    neighbor_indices = get_neighbor_indices(tree, level, linear_index)
    interaction_indices = index_set_difference(child_indices, neighbor_indices)
    return interaction_indices
end

function index_set_difference(A, B)
    return Tuple(x for x in A if !(x in B))
end

function point_to_leaf_index(tree::Tree, point)
    cartesian_index = CartesianIndex(Tuple(Int(cld(x, tree.cell_size[end])) for x in point))
    linear_index = cartesian_to_linear(
        cartesian_index, Tuple(tree.cells_per_axis[end] for _ in 1:dimension(tree))
    )
    return linear_index
end

function linear_to_cartesian(linear_index, cartesian_size)
    cartesian_indices = CartesianIndices(cartesian_size)
    return cartesian_indices[linear_index]
end

function cartesian_to_linear(cartesian_index, cartesian_size)
    cartesian_indices = CartesianIndices(cartesian_size)
    return LinearIndices(cartesian_indices)[cartesian_index]
end

function chebyshev_roots(degree::Int, x_min::Float, x_max::Float) where {Float<:AbstractFloat}
    shift = (x_max + x_min) / 2
    scale = (x_max - x_min) / 2
    return Tuple(shift + scale * cos((2 * k - 1) * Float(pi) / (2 * degree)) for k in degree:-1:1)
end

function chebyshev_weights(degree::Int, Float::Type{<:AbstractFloat}=Float64)
    return Tuple((-1)^k * sin(Float(pi) * (2 * k - 1) / (2 * degree)) for k in degree:-1:1)
end
