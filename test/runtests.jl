using Aqua
using JET
using JuliaFormatter
using Test
using TestItemRunner

using VEM

@testset "Coding standards" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(VEM; undocumented_names=true)
    end

    @testset "Code linting (JET.jl)" begin
        JET.test_package(VEM; target_defined_modules=true)
    end
end

@run_package_tests
