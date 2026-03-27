@testsnippet TestDiffusion begin
    using VEM

    mutable struct Blob <: VEM.AbstractVortexBlob{2,Float64}
        circulation::Float64
    end

    Base.zero(::Type{Blob}) = Blob(0.0)
end

@testsnippet TestDiffusionSingleNonZeroBlob begin
    mesh = CartesianMesh((4, 4), 0.25)
    mesh_size = nodes_per_axis(mesh)
    mesh_spacing = node_spacing(mesh)

    circulations = zeros(Float64, mesh_size)
    circulations[3, 3] = 1.0

    viscosity = pi * 10^-6
    time = 0.0
    time_step = 1 / (100 * exp(1))
    time_scheme = VEM.ODE.RK4()
end

@testitem "Diffuse a 5x5 grid of blobs with center non-zero" setup = [
    TestDiffusion, TestDiffusionSingleNonZeroBlob
] begin
    # GIVEN

    blobs = [Blob(circulation) for circulation in circulations]
    blobs = reshape(blobs, mesh_size)

    # WHEN

    diffusion!(blobs, viscosity, mesh, time, time_step; time_scheme=time_scheme)

    # THEN

    @test sum(blob_circulation(blob) for blob in blobs) ≈ 1
    @test count(abs(blob_circulation(blob)) > 1e-12 for blob in blobs) == 9
    @test count(!iszero(blob_circulation(blob)) for blob in blobs[2:4, 2:4]) == 9

    @test blob_circulation(blobs[2, 3]) ≈
        blob_circulation(blobs[3, 2]) ≈
        blob_circulation(blobs[3, 4]) ≈
        blob_circulation(blobs[4, 3])

    @test blob_circulation(blobs[2, 2]) ≈
        blob_circulation(blobs[2, 4]) ≈
        blob_circulation(blobs[4, 2]) ≈
        blob_circulation(blobs[4, 4])

    @test abs(blob_circulation(blobs[3, 3])) >
        abs(blob_circulation(blobs[2, 3])) >
        abs(blob_circulation(blobs[2, 2]))
end

@testsnippet TestDiffusionMultipleNonZeroBlob begin
    mesh = CartesianMesh((4, 4), 0.25)
    mesh_size = nodes_per_axis(mesh)
    mesh_spacing = node_spacing(mesh)

    circulations = zeros(Float64, mesh_size)
    circulations[2:4, 2:4] .= 1.0

    viscosity = pi * 10^-6
    time = 0.0
    time_step = 1 / (100 * exp(1))
    time_scheme = VEM.ODE.RK4()
end

@testitem "Diffuse a 5x5 grid of blobs with center 3x3 non-zero" setup = [
    TestDiffusion, TestDiffusionMultipleNonZeroBlob
] begin
    # GIVEN

    blobs = [Blob(circulation) for circulation in circulations]
    blobs = reshape(blobs, mesh_size)

    # WHEN

    diffusion!(blobs, viscosity, mesh, time, time_step; time_scheme=time_scheme)

    diffused_circulations = [blob_circulation(blob) for blob in blobs]
    diffused_circulations = reshape(diffused_circulations, mesh_size)

    # THEN

    @test sum(diffused_circulations) ≈ 9
    @test count(abs(c) > 1e-12 for c in diffused_circulations) == 25
    @test maximum(abs, diffused_circulations - diffused_circulations') < 1e-15

    @test diffused_circulations[1, 1] ≈ diffused_circulations[5, 1] ≈ diffused_circulations[5, 5]
    @test diffused_circulations[2, 2] ≈ diffused_circulations[4, 2] ≈ diffused_circulations[4, 4]
    @test diffused_circulations[2, 1] ≈
        diffused_circulations[4, 1] ≈
        diffused_circulations[5, 2] ≈
        diffused_circulations[5, 4]
    @test diffused_circulations[3, 1] ≈ diffused_circulations[3, 5]
    @test diffused_circulations[2, 3] ≈ diffused_circulations[4, 3]

    @test abs(diffused_circulations[1, 1]) <
        abs(diffused_circulations[2, 2]) <
        abs(diffused_circulations[3, 3])
end