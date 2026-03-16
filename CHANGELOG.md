# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- Abstract interface for a vortex blob: `AbstractVortexBlob`. ([#3])
- Concrete type for a Gaussian vortex blob: `GaussianVortexBlob`. ([#3])

- Abstract interface for an induced field: `AbstractInducedField`. ([#7])
- Concrete types for a velocity field and a vorticity field: `VelocityField` and `VorticityField`. ([#7])

- Computation of the field value induced by a vortex blob at a target: `induce`. ([#7])
- Multi-threaded CPU implementation for the direct summation of field inductions by a collection of vortex blobs at a collection of targets: `direct_sum` and `direct_sum!`. ([#7])

- Advection of a collection of vortex blobs: `advection!`. ([#5])

- Concrete type for a Cartesian mesh: `CartesianMesh`. ([#9])
  
- Abstract interface for a vortex-blob redistribution kernel: `AbstractRedistributionKernel`. ([#9])
- Concrete type for the M4' redistribution kernel: `M4Prime`. ([#9])

- Interpolation of  blob circulations onto Cartesian mesh nodes: `interpolate_circulation`. ([#9])
- Redistribution from olds blobs to new blobs at Cartesian mesh nodes: `redistribution`. ([#9])

### Changed

-

### Deprecaed

-   

### Removed

-

### Fixed

-

### Security

-
