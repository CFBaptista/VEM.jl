abstract type AbstractVortexBlob{Dimension, Scalar <: AbstractFloat} end

blob_dimension(::AbstractVortexBlob{Dimension}) where {Dimension} = Dimension
blob_scalar(::AbstractVortexBlob{Dimension, Scalar}) where {Dimension, Scalar} = Scalar
blob_circulation(blob::AbstractVortexBlob) = blob.circulation
blob_center(blob::AbstractVortexBlob) = blob.center
blob_radius(blob::AbstractVortexBlob) = blob.radius
