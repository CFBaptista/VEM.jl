PCT.@setup_workload begin
    PCT.@compile_workload begin
        for Dimension in (2,)
            for Scalar in (Float32, Float64)
                if Dimension == 2
                    circulation = Scalar(0.1)
                elseif Dimension == 3
                    circulation = SA.SVector{3,Scalar}(0.1, 0.2, 0.3)
                end

                center = zero(SA.SVector{Dimension,Scalar})
                radius = Scalar(0.1)
                target = zero(SA.SVector{Dimension,Scalar})

                zero(GaussianVortexBlob{Dimension,Scalar})
                zeros(GaussianVortexBlob{Dimension,Scalar}, 2)
                zeros(GaussianVortexBlob{Dimension,Scalar}, 2, 2)
                zeros(GaussianVortexBlob{Dimension,Scalar}, 2, 2, 2)

                blobs = [
                    GaussianVortexBlob(circulation, center, radius),
                    GaussianVortexBlob(circulation, center, radius),
                ]
                targets = [target, target]

                induce(VelocityField(), blobs[1], targets[1])
                induce(VorticityField(), blobs[1], targets[1])

                direct_sum(VelocityField(), blobs[1], targets[1])
                direct_sum(VelocityField(), blobs[1], targets)
                direct_sum(VelocityField(), blobs, targets[1])
                direct_sum(VelocityField(), blobs, targets)

                direct_sum(VorticityField(), blobs[1], targets[1])
                direct_sum(VorticityField(), blobs[1], targets)
                direct_sum(VorticityField(), blobs, targets[1])
                direct_sum(VorticityField(), blobs, targets)

                advection!(blobs, zero(Scalar), one(Scalar) / 10; time_scheme=ODE.Euler())
                advection!(blobs, zero(Scalar), one(Scalar) / 10; time_scheme=ODE.Midpoint())
                advection!(blobs, zero(Scalar), one(Scalar) / 10; time_scheme=ODE.RK4())

                mesh = CartesianMesh(
                    SA.SVector(zero(Scalar), zero(Scalar)), (10, 10), one(Scalar) / 10
                )

                redistribution(blobs, mesh, M4Prime())
            end
        end
    end
end
