@testsnippet VortexBlob2D begin
    const expected_dimension = 2
    const expected_scalar = Float64
    const expected_circulation = 1.0
    const expected_center = (2.0, 3.0)
    const expected_radius = 4.0

    struct Blob2D <: AbstractVortexBlob{expected_dimension,expected_scalar}
        circulation::expected_scalar
        center::NTuple{expected_dimension,expected_scalar}
        radius::expected_scalar
    end

    function create_blob()
        blob = Blob2D(expected_circulation, expected_center, expected_radius)
        return blob
    end
end

@testitem "Get blob dimension (2D)" setup=[VortexBlob2D] begin
    # GIVEN

    blob = create_blob()

    # WHEN

    dimension = blob_dimension(blob)

    # THEN

    @test dimension == expected_dimension
end

@testitem "Get blob scalar (2D)" setup=[VortexBlob2D] begin
    # GIVEN

    blob = create_blob()

    # WHEN

    scalar = blob_scalar(blob)

    # THEN

    @test scalar == expected_scalar
end

@testitem "Get blob circulation (2D)" setup=[VortexBlob2D] begin
    # GIVEN

    blob = create_blob()

    # WHEN

    circulation = blob_circulation(blob)

    # THEN

    @test circulation == expected_circulation
end

@testitem "Get blob center (2D)" setup=[VortexBlob2D] begin
    # GIVEN

    blob = create_blob()

    # WHEN

    center = blob_center(blob)

    # THEN

    @test center == expected_center
end

@testitem "Get blob radius (2D)" setup=[VortexBlob2D] begin
    # GIVEN

    blob = create_blob()

    # WHEN

    radius = blob_radius(blob)

    # THEN

    @test radius == expected_radius
end

@testsnippet VortexBlob3D begin
    const expected_dimension = 3
    const expected_scalar = Float64
    const expected_circulation = (1.0, 2.0, 3.0)
    const expected_center = (4.0, 5.0, 6.0)
    const expected_radius = 7.0

    struct Blob3D <: AbstractVortexBlob{expected_dimension,expected_scalar}
        circulation::NTuple{expected_dimension,expected_scalar}
        center::NTuple{expected_dimension,expected_scalar}
        radius::expected_scalar
    end

    function create_blob()
        blob = Blob3D(expected_circulation, expected_center, expected_radius)
        return blob
    end
end

@testitem "Get blob dimension (3D)" setup=[VortexBlob3D] begin
    # GIVEN

    blob = create_blob()

    # WHEN

    dimension = blob_dimension(blob)

    # THEN

    @test dimension == expected_dimension
end

@testitem "Get blob scalar (3D)" setup=[VortexBlob3D] begin
    # GIVEN

    blob = create_blob()

    # WHEN

    scalar = blob_scalar(blob)

    # THEN

    @test scalar == expected_scalar
end

@testitem "Get blob circulation (3D)" setup=[VortexBlob3D] begin
    # GIVEN

    blob = create_blob()

    # WHEN

    circulation = blob_circulation(blob)

    # THEN

    @test circulation == expected_circulation
end

@testitem "Get blob center (3D)" setup=[VortexBlob3D] begin
    # GIVEN

    blob = create_blob()

    # WHEN

    center = blob_center(blob)

    # THEN

    @test center == expected_center
end

@testitem "Get blob radius (3D)" setup=[VortexBlob3D] begin
    # GIVEN

    blob = create_blob()

    # WHEN

    radius = blob_radius(blob)

    # THEN

    @test radius == expected_radius
end
