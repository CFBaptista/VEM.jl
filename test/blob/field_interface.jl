@testmodule TestFieldInterface2D begin
    using VEM

    # GIVEN

    struct Blob <: VEM.AbstractVortexBlob{2,Float64}
        circulation::Float64
        center::VEM.SA.SVector{2,Float64}
        radius::Float64
    end

    blob = Blob(1.0, [0.5, 0.5], 0.1)

    expected_velocity_type = VEM.SA.SVector{2,Float64}
    expected_vorticity_type = Float64
end

@testitem "2D velocity field value is a 2D SVector" setup = [TestFieldInterface2D] begin
    # WHEN

    type = field_scalar(VelocityField(), TestFieldInterface2D.blob)

    # THEN

    @test type == TestFieldInterface2D.expected_velocity_type
end

@testitem "2D vorticity field value is a float" setup = [TestFieldInterface2D] begin
    # WHEN

    type = field_scalar(VorticityField(), TestFieldInterface2D.blob)

    # THEN

    @test type == TestFieldInterface2D.expected_vorticity_type
end

@testmodule TestFieldInterface3D begin
    using VEM

    # GIVEN

    struct Blob <: VEM.AbstractVortexBlob{3,Float64}
        circulation::VEM.SA.SVector{3,Float64}
        center::VEM.SA.SVector{3,Float64}
        radius::Float64
    end

    blob = Blob(
        VEM.SA.SVector{3,Float64}(1.0, 0.0, 0.0), VEM.SA.SVector{3,Float64}(0.5, 0.5, 0.5), 0.1
    )

    expected_velocity_type = VEM.SA.SVector{3,Float64}
    expected_vorticity_type = VEM.SA.SVector{3,Float64}
end

@testitem "3D velocity field value is a 3D SVector" setup = [TestFieldInterface3D] begin
    # WHEN

    type = field_scalar(VelocityField(), TestFieldInterface3D.blob)

    # THEN

    @test type == TestFieldInterface3D.expected_velocity_type
end

@testitem "3D vorticity field value is a 3D SVector" setup = [TestFieldInterface3D] begin
    # WHEN

    type = field_scalar(VorticityField(), TestFieldInterface3D.blob)

    # THEN

    @test type == TestFieldInterface3D.expected_vorticity_type
end
