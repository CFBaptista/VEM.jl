using VEM
using Documenter

DocMeta.setdocmeta!(VEM, :DocTestSetup, :(using VEM); recursive=true)

makedocs(;
    modules=[VEM],
    authors="Carlos Fernando Baptista <cfd.baptista@gmail.com>",
    sitename="VEM.jl",
    format=Documenter.HTML(;
        canonical="https://CFBaptista.github.io/VEM.jl",
        edit_link="master",
        assets=String[],
    ),
    doctest=true,
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/CFBaptista/VEM.jl",
    devbranch="master",
    push_preview=true,
)
