using VEM
using Documenter

DocMeta.setdocmeta!(VEM, :DocTestSetup, :(using VEM))

makedocs(;
    modules=[VEM],
    authors="Carlos Fernando Baptista <cfd.baptista@gmail.com>",
    sitename="VEM.jl",
    format=Documenter.HTML(;
        canonical="https://CFBaptista.github.io/VEM.jl/stable/", assets=String[]
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/CFBaptista/VEM.jl", push_preview=true)
