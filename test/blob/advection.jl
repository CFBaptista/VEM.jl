@testmodule TestAdvection begin
    using VEM

    mutable struct Blob{Dimension,Scalar} <: VEM.AbstractVortexBlob{Dimension,Scalar}
        circulation::Float64
        center::VEM.SA.SVector{Dimension,Scalar}
    end

    Blob(circulation, center) = Blob{length(center),eltype(center)}(circulation, center)

    function VEM.induced_velocity(blob::Blob, target)
        distance = target - blob.center
        distance_squared = VEM.LA.dot(distance, distance)

        if distance_squared == 0.0
            return VEM.SA.SVector{2,Float64}(0.0, 0.0)
        end

        c = blob.circulation / (distance_squared * pi * 2)

        velocity = VEM.SA.SVector{2,Float64}(-c * distance[2], c * distance[1])
        return velocity
    end
end

@testitem "Single vortex blob does not move" setup = [TestAdvection] begin
    # GIVEN

    x0 = 0.1078344382831602
    y0 = 0.6743443475905457

    blobs = [TestAdvection.Blob(0.9146286948409205, (x0, y0))]

    time_span = (0.0, 0.7072498016580939)
    number_of_steps = 90
    time_step = (time_span[2] - time_span[1]) / number_of_steps

    # WHEN / THEN

    for step in 1:number_of_steps
        time = time_span[1] + (step - 1) * time_step
        TestAdvection.advection!(blobs, time, time_step)

        @test isapprox(blobs[1].center, [x0, y0]; rtol=1e-15)
    end
end

@testitem "Opposite-circulation vortex blob pair translate linearly" setup = [TestAdvection] begin
    # GIVEN

    x0 = 0.4771646897488281
    y0 = 0.4708430990547343
    r = 0.3421682552533235

    blobs = [
        TestAdvection.Blob(0.4883797515506063, (x0, y0 + r)),
        TestAdvection.Blob(-0.4883797515506063, (x0, y0 - r)),
    ]

    time_span = (0.0, 0.9737449132258409)
    number_of_steps = 90
    time_step = (time_span[2] - time_span[1]) / number_of_steps

    # WHEN / THEN

    for step in 1:number_of_steps
        time = time_span[1] + (step - 1) * time_step
        TestAdvection.advection!(blobs, time, time_step)

        v = blob_circulation(blobs[1]) / (2 * pi * 2 * r)
        x = x0 + v * step * time_step

        @test isapprox(blobs[1].center, [x, y0 + r]; rtol=1e-6)
        @test isapprox(blobs[2].center, [x, y0 - r]; rtol=1e-6)
    end
end

@testitem "Equal-circulation vortex blob pair moves in a circle" setup = [TestAdvection] begin
    # GIVEN

    x0 = 0.4734651162451765
    y0 = 0.5930421656898341
    r = 0.12296572931095451

    blobs = [
        TestAdvection.Blob(0.9794752918665872, (x0, y0 + r)),
        TestAdvection.Blob(0.9794752918665872, (x0, y0 - r)),
    ]

    time_span = (0.0, 1.2188897564372894)
    number_of_steps = 90
    time_step = (time_span[2] - time_span[1]) / number_of_steps

    # WHEN / THEN

    for step in 1:number_of_steps
        time = time_span[1] + (step - 1) * time_step
        TestAdvection.advection!(blobs, time, time_step)

        theta1 = (0.5 + 2 * step / number_of_steps) * pi
        x1 = x0 + r * cos(theta1)
        y1 = y0 + r * sin(theta1)

        theta2 = theta1 + pi
        x2 = x0 + r * cos(theta2)
        y2 = y0 + r * sin(theta2)

        @test isapprox(blobs[1].center, [x1, y1]; rtol=1e-6)
        @test isapprox(blobs[2].center, [x2, y2]; rtol=1e-6)
    end
end

@testitem "Advect blobs with Euler time scheme" setup = [TestAdvection] begin
    # GIVEN

    x0 = 0.4771646897488281
    y0 = 0.4708430990547343
    r = 0.3421682552533235

    blobs = [
        TestAdvection.Blob(0.4883797515506063, (x0, y0 + r)),
        TestAdvection.Blob(-0.4883797515506063, (x0, y0 - r)),
    ]

    time_span = (0.0, 0.9737449132258409)
    number_of_steps = 90
    time_step = (time_span[2] - time_span[1]) / number_of_steps

    # WHEN / THEN

    time = time_span[1]
    TestAdvection.advection!(blobs, time, time_step; time_scheme=VEM.ODE.Euler())

    v = blob_circulation(blobs[1]) / (2 * pi * 2 * r)
    x = x0 + v * time_step

    @test isapprox(blobs[1].center, [x, y0 + r]; rtol=1e-6)
    @test isapprox(blobs[2].center, [x, y0 - r]; rtol=1e-6)
end

@testitem "Advect blobs with Midpoint time scheme" setup = [TestAdvection] begin
    # GIVEN

    x0 = 0.4771646897488281
    y0 = 0.4708430990547343
    r = 0.3421682552533235

    blobs = [
        TestAdvection.Blob(0.4883797515506063, (x0, y0 + r)),
        TestAdvection.Blob(-0.4883797515506063, (x0, y0 - r)),
    ]

    time_span = (0.0, 0.9737449132258409)
    number_of_steps = 90
    time_step = (time_span[2] - time_span[1]) / number_of_steps

    # WHEN / THEN

    time = time_span[1]
    TestAdvection.advection!(blobs, time, time_step; time_scheme=VEM.ODE.Midpoint())

    v = blob_circulation(blobs[1]) / (2 * pi * 2 * r)
    x = x0 + v * time_step

    @test isapprox(blobs[1].center, [x, y0 + r]; rtol=1e-6)
    @test isapprox(blobs[2].center, [x, y0 - r]; rtol=1e-6)
end

@testitem "Advect blobs with Runge Kutta 4 time scheme" setup = [TestAdvection] begin
    # GIVEN

    x0 = 0.4771646897488281
    y0 = 0.4708430990547343
    r = 0.3421682552533235

    blobs = [
        TestAdvection.Blob(0.4883797515506063, (x0, y0 + r)),
        TestAdvection.Blob(-0.4883797515506063, (x0, y0 - r)),
    ]

    time_span = (0.0, 0.9737449132258409)
    number_of_steps = 90
    time_step = (time_span[2] - time_span[1]) / number_of_steps

    # WHEN / THEN

    time = time_span[1]
    TestAdvection.advection!(blobs, time, time_step; time_scheme=VEM.ODE.RK4())

    v = blob_circulation(blobs[1]) / (2 * pi * 2 * r)
    x = x0 + v * time_step

    @test isapprox(blobs[1].center, [x, y0 + r]; rtol=1e-6)
    @test isapprox(blobs[2].center, [x, y0 - r]; rtol=1e-6)
end
