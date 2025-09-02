using Changelog
using Documenter

using VEM

DocMeta.setdocmeta!(VEM, :DocTestSetup, :(using VEM); recursive=true)

Changelog.generate(
    Changelog.Documenter(),
    joinpath(@__DIR__, "../CHANGELOG.md"),
    joinpath(@__DIR__, "src/CHANGELOG.md");
    repo="CFBaptista/VEM.jl",
)

makedocs(;
    modules=[VEM],
    authors="Carlos Fernando Baptista <cfd.baptista@gmail.com>",
    sitename="VEM.jl",
    format=Documenter.HTML(;
        canonical="https://CFBaptista.github.io/VEM.jl", edit_link="master", assets=String[]
    ),
    doctest=true,
    pages=["Home" => "index.md", "API" => "api.md", "Changelog" => "CHANGELOG.md"],
)

deploydocs(; repo="github.com/CFBaptista/VEM.jl", devbranch="master", push_preview=true)
