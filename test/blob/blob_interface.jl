@testmodule TestBlobInterface2D begin
    using VEM

    # GIVEN

    mutable struct Blob{D,T} <: VEM.AbstractVortexBlob{D,T}
        circulation::T
        center::VEM.SA.SVector{D,T}
        radius::T
    end

    function Base.zero(::Type{Blob{D,T}}) where {D,T}
        return Blob(zero(T), zero(VEM.SA.SVector{D,T}), zero(T))
    end

    expected_circulation = 1.0
    expected_center = VEM.SA.SVector(0.5, 0.5)
    expected_radius = 0.1

    blob = Blob(expected_circulation, expected_center, expected_radius)
end

@testitem "Get vortex blob type parameters" setup = [TestBlobInterface2D] begin
    # WHEN

    Dimension = blob_dimension(TestBlobInterface2D.blob)
    Scalar = blob_scalar(TestBlobInterface2D.blob)

    # THEN

    @test Dimension == 2
    @test Scalar == Float64
end

@testitem "Create vortex blob with zero data" setup = [TestBlobInterface2D] begin
    # WHEN

    zero_blob = zero(TestBlobInterface2D.blob)

    # THEN

    @test blob_circulation(zero_blob) == 0.0
    @test blob_center(zero_blob) == [0.0, 0.0]
    @test blob_radius(zero_blob) == 0.0
end

@testitem "Get vortex blob data" setup = [TestBlobInterface2D] begin
    # WHEN

    circulation = blob_circulation(TestBlobInterface2D.blob)
    center = blob_center(TestBlobInterface2D.blob)
    radius = blob_radius(TestBlobInterface2D.blob)

    # THEN

    @test circulation == TestBlobInterface2D.expected_circulation
    @test center == TestBlobInterface2D.expected_center
    @test radius == TestBlobInterface2D.expected_radius
end

@testitem "Update vortex blob data" setup = [TestBlobInterface2D] begin
    # GIVEN

    new_expected_circulation = 2.0
    new_expected_center = typeof(TestBlobInterface2D.expected_center)(0.6, 0.6)
    new_expected_radius = 0.2

    # WHEN

    blob_circulation!(TestBlobInterface2D.blob, new_expected_circulation)
    blob_center!(TestBlobInterface2D.blob, new_expected_center)
    blob_radius!(TestBlobInterface2D.blob, new_expected_radius)

    # THEN

    @test blob_circulation(TestBlobInterface2D.blob) == new_expected_circulation
    @test blob_center(TestBlobInterface2D.blob) == new_expected_center
    @test blob_radius(TestBlobInterface2D.blob) == new_expected_radius
end

@testmodule TestBlobInterface3D begin
    using VEM

    # GIVEN

    mutable struct Blob{D,T} <: VEM.AbstractVortexBlob{D,T}
        circulation::VEM.SA.SVector{D,T}
        center::VEM.SA.SVector{D,T}
        radius::T
    end

    function Base.zero(::Type{Blob{D,T}}) where {D,T}
        return Blob(zero(VEM.SA.SVector{D,T}), zero(VEM.SA.SVector{D,T}), zero(T))
    end

    expected_circulation = VEM.SA.SVector(1.0, 0.0, 0.0)
    expected_center = VEM.SA.SVector(0.5, 0.5, 0.5)
    expected_radius = 0.1

    blob = Blob(expected_circulation, expected_center, expected_radius)
end

@testitem "Get vortex blob type parameters" setup = [TestBlobInterface3D] begin
    # WHEN

    Dimension = blob_dimension(TestBlobInterface3D.blob)
    Scalar = blob_scalar(TestBlobInterface3D.blob)

    # THEN

    @test Dimension == 3
    @test Scalar == Float64
end

@testitem "Create vortex blob with zero data" setup = [TestBlobInterface3D] begin
    # WHEN

    zero_blob = zero(TestBlobInterface3D.blob)

    # THEN

    @test blob_circulation(zero_blob) == [0.0, 0.0, 0.0]
    @test blob_center(zero_blob) == [0.0, 0.0, 0.0]
    @test blob_radius(zero_blob) == 0.0
end

@testitem "Get vortex blob data" setup = [TestBlobInterface3D] begin
    # WHEN

    circulation = blob_circulation(TestBlobInterface3D.blob)
    center = blob_center(TestBlobInterface3D.blob)
    radius = blob_radius(TestBlobInterface3D.blob)

    # THEN

    @test circulation == TestBlobInterface3D.expected_circulation
    @test center == TestBlobInterface3D.expected_center
    @test radius == TestBlobInterface3D.expected_radius
end

@testitem "Update vortex blob data" setup = [TestBlobInterface3D] begin
    # GIVEN

    new_expected_circulation = VEM.SA.SVector(2.0, 0.0, 0.0)
    new_expected_center = typeof(TestBlobInterface3D.expected_center)(0.6, 0.6, 0.6)
    new_expected_radius = 0.2

    # WHEN

    blob_circulation!(TestBlobInterface3D.blob, new_expected_circulation)
    blob_center!(TestBlobInterface3D.blob, new_expected_center)
    blob_radius!(TestBlobInterface3D.blob, new_expected_radius)

    # THEN

    @test blob_circulation(TestBlobInterface3D.blob) == new_expected_circulation
    @test blob_center(TestBlobInterface3D.blob) == new_expected_center
    @test blob_radius(TestBlobInterface3D.blob) == new_expected_radius
end
