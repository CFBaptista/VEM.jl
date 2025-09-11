module VEM

import LinearAlgebra as LA

import FillArrays as FA
import PrecompileTools as PCT
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

include("blob/gaussian_blob.jl")
export GaussianVortexBlob
export induced_velocity
export induced_vorticity

include("blob/induction.jl")
export superpose_induced_fields
export superpose_induced_fields!

include("precompile.jl")

end
