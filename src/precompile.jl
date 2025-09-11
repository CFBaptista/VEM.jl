PCT.@setup_workload begin
    PCT.@compile_workload begin
        for Dimension in (2,)
            for Scalar in (Float32, Float64)
                if Dimension == 2
                    circulation = Scalar(0)
                elseif Dimension == 3
                    circulation = SA.SVector{3,Scalar}(0, 0, 0)
                end

                center = zero(SA.SVector{Dimension,Scalar})
                radius = Scalar(0)
                target = zero(SA.SVector{Dimension,Scalar})

                blobs = [
                    GaussianVortexBlob(circulation, center, radius),
                    GaussianVortexBlob(circulation, center, radius),
                ]
                targets = [target, target]

                induced_velocity(blobs[1], targets[1])
                induced_vorticity(blobs[1], targets[1])

                superpose_induced_fields(induced_velocity, blobs[1], targets[1])
                superpose_induced_fields(induced_velocity, blobs[1], targets)
                superpose_induced_fields(induced_velocity, blobs, targets[1])
                superpose_induced_fields(induced_velocity, blobs, targets)

                superpose_induced_fields(induced_vorticity, blobs[1], targets[1])
                superpose_induced_fields(induced_vorticity, blobs[1], targets)
                superpose_induced_fields(induced_vorticity, blobs, targets[1])
                superpose_induced_fields(induced_vorticity, blobs, targets)
            end
        end
    end
end
