# VEM.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://CFBaptista.github.io/VEM.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://CFBaptista.github.io/VEM.jl/dev/)
[![Build Status](https://github.com/CFBaptista/VEM.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/CFBaptista/VEM.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/CFBaptista/VEM.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/CFBaptista/VEM.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

VEM (**V**ortex **E**lement **M**ethod) is a library for computational fluid dynamics based on the evolution of vorticity.
The fluid dynamics are governed by the Navier-Stokes equation in its velocity-vorticity formulation.
Circulation-carrying computational elements called vortex elements induce a vorticity field which represents the entire flow field.
An increasing amount of approaches exist for evolving the vortex elements in time.
This library is meant for collecting all approaches in a single package.
