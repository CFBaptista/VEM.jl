@testmodule TestBlob begin
    using VEM

    struct Blob{Dimension,Scalar} <: VEM.AbstractVortexBlob{Dimension,Scalar}
        center::VEM.SA.SVector{Dimension,Scalar}
    end

    Blob(center) = Blob{length(center),eltype(center)}(center)

    VEM.induced_velocity(blob::Blob, target) = target - blob.center
end

@testitem "Single blob single target" setup = [TestBlob] begin
    # GIVEN

    center = [0.6152631005751957, 0.18811339879309474]
    target = [0.7878535040075554, 0.6469266964176182]
    expected_result = [target - center]

    blob = TestBlob.Blob(center)

    # WHEN

    result = superpose_induced_fields(induced_velocity, blob, target)

    # THEN

    @test all(isapprox.(result, expected_result; rtol=1e-12))
end

@testitem "Single blob single target (in-place)" setup = [TestBlob] begin
    # GIVEN

    induction(blob, target) = target - blob.center

    center = [0.6152631005751957, 0.18811339879309474]
    target = [0.7878535040075554, 0.6469266964176182]
    expected_result = [target - center]

    blob = TestBlob.Blob(center)

    result = zero(expected_result)

    # WHEN

    superpose_induced_fields!(result, induction, blob, target)

    # THEN

    @test all(isapprox.(result, expected_result; rtol=1e-12))
end

@testitem "Single blob multiple targets" setup = [TestBlob] begin
    # GIVEN

    center = [0.025098073771080753, 0.3738542048733142]
    targets = [
        [0.17543661398218324, 0.743811010016449],
        [0.6998863016059247, 0.3438879064431085],
        [0.19707332442316117, 0.5775108410158248],
    ]
    expected_result = [target - center for target in targets]

    blob = TestBlob.Blob(center)

    # WHEN

    result = superpose_induced_fields(induced_velocity, blob, targets)

    # THEN

    for (x, y) in zip(result, expected_result)
        @test all(isapprox.(x, y; rtol=1e-12))
    end
end

@testitem "Single blob multiple targets (in-place)" setup = [TestBlob] begin
    # GIVEN

    induction(blob, target) = target - blob.center

    center = [0.025098073771080753, 0.3738542048733142]
    targets = [
        [0.17543661398218324, 0.743811010016449],
        [0.6998863016059247, 0.3438879064431085],
        [0.19707332442316117, 0.5775108410158248],
    ]
    expected_result = [target - center for target in targets]

    blob = TestBlob.Blob(center)

    result = zero(expected_result)

    # WHEN

    superpose_induced_fields!(result, induction, blob, targets)

    # THEN

    for (x, y) in zip(result, expected_result)
        @test all(isapprox.(x, y; rtol=1e-12))
    end
end

@testitem "Multiple blobs single target" setup = [TestBlob] begin
    # GIVEN

    centers = [
        [0.7014982662114765, 0.37413148268776764],
        [0.5092038562572166, 0.32680395387189864],
        [0.2530096214871568, 0.1403377625307627],
    ]
    target = [0.013388563215556704, 0.2472053407499939]
    expected_result = [sum(target - center for center in centers)]

    blobs = [TestBlob.Blob(center) for center in centers]

    # WHEN

    result = superpose_induced_fields(induced_velocity, blobs, target)

    # THEN

    @test all(isapprox.(result, expected_result; rtol=1e-12))
end

@testitem "Multiple blobs single target (in-place)" setup = [TestBlob] begin
    # GIVEN

    induction(blob, target) = target - blob.center

    centers = [
        [0.7014982662114765, 0.37413148268776764],
        [0.5092038562572166, 0.32680395387189864],
        [0.2530096214871568, 0.1403377625307627],
    ]
    target = [0.013388563215556704, 0.2472053407499939]
    expected_result = [sum(target - center for center in centers)]

    blobs = [TestBlob.Blob(center) for center in centers]

    result = zero(expected_result)

    # WHEN

    superpose_induced_fields!(result, induction, blobs, target)

    # THEN

    @test all(isapprox.(result, expected_result; rtol=1e-12))
end

@testitem "Multiple blobs multiple targets" setup = [TestBlob] begin
    # GIVEN

    centers = [
        [0.8204700210355016, 0.8208193900068033],
        [0.15325130694336409, 0.8561836357829848],
        [0.963601164863499, 0.9122089906784491],
    ]
    targets = [
        [0.742561728483886, 0.6513592635559914],
        [0.5684840571526122, 0.8422846505176326],
        [0.9788982932234188, 0.4349865893258398],
    ]
    expected_result = [sum(target - center for center in centers) for target in targets]

    blobs = [TestBlob.Blob(center) for center in centers]

    # WHEN

    result = superpose_induced_fields(induced_velocity, blobs, targets)

    # THEN

    for (x, y) in zip(result, expected_result)
        @test all(isapprox.(x, y; rtol=1e-12))
    end
end

@testitem "Multiple blobs multiple targets (in-place)" setup = [TestBlob] begin
    # GIVEN

    induction(blob, target) = target - blob.center

    centers = [
        [0.8204700210355016, 0.8208193900068033],
        [0.15325130694336409, 0.8561836357829848],
        [0.963601164863499, 0.9122089906784491],
    ]
    targets = [
        [0.742561728483886, 0.6513592635559914],
        [0.5684840571526122, 0.8422846505176326],
        [0.9788982932234188, 0.4349865893258398],
    ]
    expected_result = [sum(target - center for center in centers) for target in targets]

    blobs = [TestBlob.Blob(center) for center in centers]

    result = zero(expected_result)

    # WHEN

    superpose_induced_fields!(result, induction, blobs, targets)

    # THEN

    for (x, y) in zip(result, expected_result)
        @test all(isapprox.(x, y; rtol=1e-12))
    end
end

@testitem "Return type for 2D induced velocity is a 2-vector" begin
    # GIVEN

    induction = induced_velocity
    blob_type = AbstractVortexBlob{2,Float}
    expected_return_type = VEM.SA.SVector{2,Float}

    # WHEN

    return_type = VEM.induction_return_type(induction, blob_type)

    # THEN

    @test return_type == expected_return_type
end

@testitem "Return type for 2D induced vorticity is a scalar" begin
    # GIVEN

    induction = induced_vorticity
    blob_type = AbstractVortexBlob{2,Float}
    expected_return_type = Float

    # WHEN

    return_type = VEM.induction_return_type(induction, blob_type)

    # THEN

    @test return_type == expected_return_type
end

@testitem "Return type for 3D induced velocity is a 3-vector" begin
    # GIVEN

    induction = induced_velocity
    blob_type = AbstractVortexBlob{3,Float}
    expected_return_type = VEM.SA.SVector{3,Float}

    # WHEN

    return_type = VEM.induction_return_type(induction, blob_type)

    # THEN

    @test return_type == expected_return_type
end

@testitem "Return type for 3D induced vorticity is a 3-vector" begin
    # GIVEN

    induction = induced_vorticity
    blob_type = AbstractVortexBlob{3,Float}
    expected_return_type = VEM.SA.SVector{3,Float}

    # WHEN

    return_type = VEM.induction_return_type(induction, blob_type)

    # THEN

    @test return_type == expected_return_type
end
