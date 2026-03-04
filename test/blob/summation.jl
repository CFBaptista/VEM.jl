@testmodule TestInduction begin
    using VEM

    struct Blob{Dimension,Scalar} <: VEM.AbstractVortexBlob{Dimension,Scalar}
        center::VEM.SA.SVector{Dimension,Scalar}
    end

    Blob(center) = Blob{length(center),eltype(center)}(center)

    VEM.induce(::VEM.VelocityField, blob::Blob, target) = target - blob.center
end

@testitem "Single blob single target" setup = [TestInduction] begin
    # GIVEN

    center = [0.6152631005751957, 0.18811339879309474]
    target = [0.7878535040075554, 0.6469266964176182]
    expected_result = [target - center]

    blob = TestInduction.Blob(center)

    # WHEN

    result = direct_sum(VelocityField(), blob, target)

    # THEN

    @test all(isapprox.(result, expected_result; rtol=1e-12))
end

@testitem "Single blob single target (in-place)" setup = [TestInduction] begin
    # GIVEN

    induce(::VelocityField, blob::TestInduction.Blob, target) = target - blob.center

    center = [0.6152631005751957, 0.18811339879309474]
    target = [0.7878535040075554, 0.6469266964176182]
    expected_result = [target - center]

    blob = TestInduction.Blob(center)

    result = zero(expected_result)

    # WHEN

    direct_sum!(result, VelocityField(), blob, target)

    # THEN

    @test all(isapprox.(result, expected_result; rtol=1e-12))
end

@testitem "Single blob multiple targets" setup = [TestInduction] begin
    # GIVEN

    center = [0.025098073771080753, 0.3738542048733142]
    targets = [
        [0.17543661398218324, 0.743811010016449],
        [0.6998863016059247, 0.3438879064431085],
        [0.19707332442316117, 0.5775108410158248],
    ]
    expected_result = [target - center for target in targets]

    blob = TestInduction.Blob(center)

    # WHEN

    result = direct_sum(VelocityField(), blob, targets)

    # THEN

    for (x, y) in zip(result, expected_result)
        @test all(isapprox.(x, y; rtol=1e-12))
    end
end

@testitem "Single blob multiple targets (in-place)" setup = [TestInduction] begin
    # GIVEN

    induce(::VelocityField, blob::TestInduction.Blob, target) = target - blob.center

    center = [0.025098073771080753, 0.3738542048733142]
    targets = [
        [0.17543661398218324, 0.743811010016449],
        [0.6998863016059247, 0.3438879064431085],
        [0.19707332442316117, 0.5775108410158248],
    ]
    expected_result = [target - center for target in targets]

    blob = TestInduction.Blob(center)

    result = zero(expected_result)

    # WHEN

    direct_sum!(result, VelocityField(), blob, targets)

    # THEN

    for (x, y) in zip(result, expected_result)
        @test all(isapprox.(x, y; rtol=1e-12))
    end
end

@testitem "Multiple blobs single target" setup = [TestInduction] begin
    # GIVEN

    centers = [
        [0.7014982662114765, 0.37413148268776764],
        [0.5092038562572166, 0.32680395387189864],
        [0.2530096214871568, 0.1403377625307627],
    ]
    target = [0.013388563215556704, 0.2472053407499939]
    expected_result = [sum(target - center for center in centers)]

    blobs = [TestInduction.Blob(center) for center in centers]

    # WHEN

    result = direct_sum(VelocityField(), blobs, target)

    # THEN

    @test all(isapprox.(result, expected_result; rtol=1e-12))
end

@testitem "Multiple blobs single target (in-place)" setup = [TestInduction] begin
    # GIVEN

    induce(::VelocityField, blob::TestInduction.Blob, target) = target - blob.center

    centers = [
        [0.7014982662114765, 0.37413148268776764],
        [0.5092038562572166, 0.32680395387189864],
        [0.2530096214871568, 0.1403377625307627],
    ]
    target = [0.013388563215556704, 0.2472053407499939]
    expected_result = [sum(target - center for center in centers)]

    blobs = [TestInduction.Blob(center) for center in centers]

    result = zero(expected_result)

    # WHEN

    direct_sum!(result, VelocityField(), blobs, target)

    # THEN

    @test all(isapprox.(result, expected_result; rtol=1e-12))
end

@testitem "Multiple blobs multiple targets" setup = [TestInduction] begin
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

    blobs = [TestInduction.Blob(center) for center in centers]

    # WHEN

    result = direct_sum(VelocityField(), blobs, targets)

    # THEN

    for (x, y) in zip(result, expected_result)
        @test all(isapprox.(x, y; rtol=1e-12))
    end
end

@testitem "Multiple blobs multiple targets (in-place)" setup = [TestInduction] begin
    # GIVEN

    induce(::VelocityField, blob::TestInduction.Blob, target) = target - blob.center

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

    blobs = [TestInduction.Blob(center) for center in centers]

    result = zero(expected_result)

    # WHEN

    direct_sum!(result, VelocityField(), blobs, targets)

    # THEN

    for (x, y) in zip(result, expected_result)
        @test all(isapprox.(x, y; rtol=1e-12))
    end
end
