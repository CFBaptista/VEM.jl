using SafeTestsets

@time @safetestset "Code quality (Aqua.jl)" include("aqua.jl")
@time @safetestset "Singular vortex particle" include("singular_vortex_particle.jl")
