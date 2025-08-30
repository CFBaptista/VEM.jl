@testsnippet VortexBlob2D begin
    struct Blob{Dimension, Scalar} <: AbstractVortexBlob{Dimension, Scalar}
        circulation::Scalar
        center::NTuple{Dimension, Scalar}
        radius::Scalar
    end

    function create_blob()
        blob = Blob{2, Float64}(1.0, (2.0, 3.0), 4.0)
        return blob
    end
end

@testitem "Get blob dimension (2D)" setup=[VortexBlob2D] begin
    # GIVEN

    expected_dimension = 2
    blob = create_blob()

    # WHEN

    dimension = blob_dimension(blob)

    # THEN

    @test dimension == expected_dimension
end

@testitem "Get blob scalar (2D)" setup=[VortexBlob2D] begin
    # GIVEN

    expected_scalar = Float64
    blob = create_blob()

    # WHEN

    scalar = blob_scalar(blob)

    # THEN

    @test scalar == expected_scalar
end

@testitem "Get blob circulation (2D)" setup=[VortexBlob2D] begin
    # GIVEN

    expected_circulation = 1.0
    blob = create_blob()

    # WHEN

    circulation = blob_circulation(blob)

    # THEN

    @test circulation == expected_circulation
end

@testitem "Get blob center (2D)" setup=[VortexBlob2D] begin
    # GIVEN

    expected_center = (2.0, 3.0)
    blob = create_blob()

    # WHEN

    center = blob_center(blob)

    # THEN

    @test center == expected_center
end

@testitem "Get blob radius (2D)" setup=[VortexBlob2D] begin
    # GIVEN

    expected_radius = 4.0
    blob = create_blob()

    # WHEN

    radius = blob_radius(blob)

    # THEN

    @test radius == expected_radius
end

@testsnippet VortexBlob3D begin
    struct Blob{Dimension, Scalar} <: AbstractVortexBlob{Dimension, Scalar}
        circulation::NTuple{Dimension, Scalar}
        center::NTuple{Dimension, Scalar}
        radius::Scalar
    end

    function create_blob()
        blob = Blob{3, Float64}((1.0, 2.0, 3.0), (4.0, 5.0, 6.0), 7.0)
        return blob
    end
end

@testitem "Get blob dimension (3D)" setup=[VortexBlob3D] begin
    # GIVEN

    expected_dimension = 3
    blob = create_blob()

    # WHEN

    dimension = blob_dimension(blob)

    # THEN

    @test dimension == expected_dimension
end

@testitem "Get blob scalar (3D)" setup=[VortexBlob3D] begin
    # GIVEN

    expected_scalar = Float64
    blob = create_blob()

    # WHEN

    scalar = blob_scalar(blob)

    # THEN

    @test scalar == expected_scalar
end

@testitem "Get blob circulation (3D)" setup=[VortexBlob3D] begin
    # GIVEN

    expected_circulation = (1.0, 2.0, 3.0)
    blob = create_blob()

    # WHEN

    circulation = blob_circulation(blob)

    # THEN

    @test circulation == expected_circulation
end

@testitem "Get blob center (3D)" setup=[VortexBlob3D] begin
    # GIVEN

    expected_center = (4.0, 5.0, 6.0)
    blob = create_blob()

    # WHEN

    center = blob_center(blob)

    # THEN

    @test center == expected_center
end

@testitem "Get blob radius (3D)" setup=[VortexBlob3D] begin
    # GIVEN

    expected_radius = 7.0
    blob = create_blob()

    # WHEN

    radius = blob_radius(blob)

    # THEN

    @test radius == expected_radius
end
