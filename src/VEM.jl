module VEM

import LinearAlgebra as LA

import FillArrays as FA
import OrdinaryDiffEq as ODE
import PrecompileTools as PCT
import RecursiveArrayTools as RAT
import StaticArrays as SA

include("definitions.jl")
export Float

include("blob/blob_interface.jl")
export AbstractVortexBlob
export blob_dimension
export blob_scalar
export blob_circulation
export blob_circulation!
export blob_center
export blob_center!
export blob_radius
export blob_radius!

include("blob/blob_utilities.jl")

include("blob/induced_field_interface.jl")
export AbstractInducedField
export VelocityField
export VorticityField

include("blob/gaussian_blob.jl")
export GaussianVortexBlob
export induce

include("blob/summation.jl")
export direct_sum
export direct_sum!

include("blob/advection.jl")
export advection!

include("precompile.jl")

end
