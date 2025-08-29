using VEM
using Test
using Aqua
using JET

@testset "VEM.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(VEM)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(VEM; target_defined_modules = true)
    end
end
