using LinearAlgebra
using Test
using VEM

@testset "Velocity" begin
    @testset "Symmetries" begin
        @testset "GivenTranslationOfOrigin_WhenComputeVelocity_ThenSameVelocity" begin
            # ---- GIVEN ----
            circulation = 1 / 3
            source = [0.3, 0.5]
            target = [0.7, 1.1]

            translation = [1.0, 1.0]
            translated_source = source - translation
            translated_target = target - translation

            # ---- WHEN ----
            velocity_without_translation = compute_velocity(circulation, source, target)
            velocity_with_translation = compute_velocity(
                circulation, translated_source, translated_target
            )

            # ---- THEN ----
            @test velocity_without_translation ≈ velocity_with_translation
        end

        @testset "GivenRotationOfOrigin_WhenComputeVelocity_ThenSameSpeed" begin
            # ---- GIVEN ----
            circulation = 1 / 7
            source = [0.5, 0.7]
            target = [1.1, 1.7]

            rotation_angle = 30.0
            rotation_matrix = [
                cosd(-rotation_angle) -sind(-rotation_angle)
                sind(-rotation_angle) cosd(-rotation_angle)
            ]
            rotated_source = rotation_matrix * source
            rotated_target = rotation_matrix * target

            # ---- WHEN ----
            velocity_without_rotation = compute_velocity(circulation, source, target)
            velocity_with_rotation = compute_velocity(
                circulation, rotated_source, rotated_target
            )

            # ---- THEN ----
            @test norm(velocity_without_rotation) ≈ norm(velocity_with_rotation)
        end

        @testset "GivenSwitchSourceAndTarget_WhenComputeVelocity_ThenOppositeVelocity" begin
            # ---- GIVEN ----
            circulation = 1 / 11
            source = [0.7, 1.1]
            target = [1.3, 2.3]

            # ---- WHEN ----
            velocity_without_switch = compute_velocity(circulation, source, target)
            velocity_with_switch = compute_velocity(circulation, target, source)

            # ---- THEN ----
            @test velocity_without_switch ≈ -velocity_with_switch
        end
    end

    @testset "Orientation" begin
        @testset "GivenPositveHorizontalDistanceAndZeroVerticalDistance_WhenComputeVelocity_ThenZeroHorizontalVelocityAndPositveVerticalVelocity" begin
            # ---- GIVEN ----
            circulation = 1.0
            source = [3 / 7, 11 / 13]
            target = source + [3, 0]

            # ---- WHEN ----
            velocity = compute_velocity(circulation, source, target)

            # ---- THEN ----
            @test isapprox(velocity[1], 0; atol=1e-12)
            @test velocity[2] > 0
        end
    end

    @testset "Proportionality" begin
        @testset "GivenDoubleCirculation_WhenComputeVelocity_ThenDoubleVelocity" begin
            # ---- GIVEN ----
            circulation = 3 / 7
            source = [1.3, 1.7]
            target = [2.3, 2.9]

            # ---- WHEN ----
            velocity_single_circulation = compute_velocity(circulation, source, target)
            velocity_double_circulation = compute_velocity(2 * circulation, source, target)

            # ---- THEN ----
            @test velocity_double_circulation ≈ 2 * velocity_single_circulation
        end

        @testset "GivenDoubleDistance_WhenComputeVelocity_ThenHalfVelocity" begin
            # ---- GIVEN ----
            circulation = 3 / 11
            source = [0.3, 0.7]
            target = [1.3, 2.3]

            # ---- WHEN ----
            velocity_single_distance = compute_velocity(circulation, source, target)
            velocity_double_distance = compute_velocity(circulation, 2 * source, 2 * target)

            # ---- THEN ----
            @test velocity_double_distance ≈ 0.5 * velocity_single_distance
        end

        @testset "GivenUnitCirculationAndUnitDistance_WhenComputeVelocity_ThenSpeedEqualsReciprocalOfTwoPi" begin
            # ---- GIVEN ----
            circulation = 1.0
            source = [3 / 7, 11 / 13]
            target = source + [0.8, 0.6]

            # ---- WHEN ----
            velocity = compute_velocity(circulation, source, target)

            # ---- THEN ----
            @test norm(velocity) ≈ 1 / (2 * pi)
        end
    end

    @testset "Orthogonality" begin
        @testset "GivenCirculationSourceAndTarget_WhenComputeVelocity_ThenVelocityPerpendicularToDistance" begin
            # ---- GIVEN ----
            circulation = 1 / 17
            source = [0.7, 1.1]
            target = [1.3, 2.3]

            # ---- WHEN ----
            velocity = compute_velocity(circulation, source, target)

            # ---- THEN ----
            @test dot(target, velocity) ≈ dot(source, velocity)
        end
    end

    @testset "Singularity" begin
        @testset "GivenSourceEqualsTarget_WhenComputeVelocity_ThenVelocityEqualsNaN" begin
            # ---- GIVEN ----
            circulation = 1 / 13
            source = [0.3, 0.7]
            target = source

            # ---- WHEN ----
            velocity = compute_velocity(circulation, source, target)

            # ---- THEN ----
            @test all(x -> isnan(x), velocity)
        end
    end

    @testset "Return type" begin
        @testset "GivenFloatAndFloatVectorInputs_WhenComputeVelocity_ThenReturnTypeIsConcrete" begin
            # ---- GIVEN ----
            circulation_types = (Float16, Float32, Float64)
            source_types = (Vector{x} for x in circulation_types)
            target_types = (Vector{x} for x in circulation_types)

            # ---- WHEN ---- / ---- THEN ----
            for ctype in circulation_types, stype in source_types, ttype in target_types
                @test isconcretetype(
                    Core.Compiler.return_type(compute_velocity, Tuple{ctype,stype,ttype})
                )
            end
        end

        @testset "GivenFloatAndFloatVectorInputs_WhenComputeVelocity_ThenReturnTypeEqualsPromoteType" begin
            # ---- GIVEN ----
            circulation_types = (Float16, Float32, Float64)
            source_types = (Vector{x} for x in circulation_types)
            target_types = (Vector{x} for x in circulation_types)

            # ---- WHEN ---- / ---- THEN ----
            for ctype in circulation_types, stype in source_types, ttype in target_types
                @test Core.Compiler.return_type(
                    compute_velocity, Tuple{ctype,stype,ttype}
                ) == Vector{promote_type(ctype, eltype(stype), eltype(ttype))}
            end
        end
    end
end

@testset "Velocity gradient" begin
    @testset "Symmetries" begin
        @testset "GivenTranslationOfOrigin_WhenComputeVelocityGradient_ThenSameVelocityGradient" begin
            # ---- GIVEN ----
            circulation = 1 / 3
            source = [0.3, 0.5]
            target = [0.7, 1.1]

            translation = [1.0, 1.0]
            translated_source = source - translation
            translated_target = target - translation

            # ---- WHEN ----
            velocity_gradient_without_translation = compute_velocity_gradient(
                circulation, source, target
            )
            velocity_gradient_with_translation = compute_velocity_gradient(
                circulation, translated_source, translated_target
            )

            # ---- THEN ----
            @test velocity_gradient_without_translation ≈ velocity_gradient_with_translation
        end

        @testset "GivenCirculationSourceAndTarget_WhenComputeVelocityGradient_ThenSymmetricVelocityGradient" begin
            # ---- GIVEN ----
            circulation = 5 / 7
            source = [11 / 7, 13 / 7]
            target = [17 / 7, 23 / 7]

            # ---- WHEN ----
            velocity_gradient = compute_velocity_gradient(circulation, source, target)

            # ---- THEN ----
            @test velocity_gradient == velocity_gradient'
        end

        @testset "GivenHorizontalDistanceEqualsVerticalDistance_WhenComputeVelocityGradient_ThenOffDiagonalVelocityGradientsEqualZero" begin
            # ---- GIVEN ----
            circulation = 13 / 7
            source = [3 / 7, 5 / 7]
            target = source + [3 / 11, 3 / 11]

            # ---- WHEN ----
            velocity_gradient = compute_velocity_gradient(circulation, source, target)

            # ---- THEN ----
            @test velocity_gradient[2, 1] ≈ velocity_gradient[1, 2]
            @test isapprox(velocity_gradient[2, 1], 0; atol=1e-12)
        end

        @testset "GivenAbsHorizontalDistanceLargerThanAbsVerticalDistance_WhenComputeVelocityGradient_ThenOffDiagonalVelocityGradientsAreNegative" begin
            # ---- GIVEN ----
            circulation = 13 / 7
            source = [3 / 7, 5 / 7]
            target = source + [7 / 11, 3 / 11]

            # ---- WHEN ----
            velocity_gradient = compute_velocity_gradient(circulation, source, target)

            # ---- THEN ----
            @test velocity_gradient[2, 1] < 0
            @test velocity_gradient[1, 2] < 0
        end

        @testset "GivenFlipHorizontalDistance_WhenComputeVelocityGradient_ThenFlipVelocityGradientDiagonal" begin
            # ---- GIVEN ----
            circulation = 13 / 7
            source = [3 / 7, 5 / 7]
            target = [17 / 7, 23 / 7]

            source_flipped = [target[1], source[2]]
            target_flipped = [source[1], target[2]]

            # ---- WHEN ----
            velocity_gradient_without_flip = compute_velocity_gradient(
                circulation, source, target
            )
            velocity_gradient_with_flip = compute_velocity_gradient(
                circulation, source_flipped, target_flipped
            )

            # ---- THEN ----
            @test diag(velocity_gradient_without_flip) ≈ -diag(velocity_gradient_with_flip)
        end

        @testset "GivenPostiveHorizontalAndPostiveVerticalDistances_WhenComputeVelocityGradient_ThenFirstDiagonalPositveAndSecondDiagonalNegative" begin
            # ---- GIVEN ----
            circulation = 13 / 7
            source = [3 / 11, 5 / 11]
            target = [3 / 7, 5 / 7]

            # ---- WHEN ----
            velocity_gradient = compute_velocity_gradient(circulation, source, target)

            # ---- THEN ----
            @test velocity_gradient[1, 1] > 0
            @test velocity_gradient[2, 2] < 0
        end
    end

    @testset "Proportionality" begin
        @testset "GivenDoubleCiculation_WhenComputeVelocityGradient_ThenDoubleVelocityGradient" begin
            # ---- GIVEN ----
            circulation = 2 / 3
            source = [1 / 7, 2 / 7]
            target = [3 / 7, 4 / 7]

            # ---- WHEN ----
            velocity_gradient_single_circulation = compute_velocity_gradient(
                circulation, source, target
            )
            velocity_gradient_double_circulation = compute_velocity_gradient(
                2 * circulation, source, target
            )

            # ---- THEN ----
            @test velocity_gradient_double_circulation ≈
                2 * velocity_gradient_single_circulation
        end

        @testset "GivenDoubleDistance_WhenComputeVelocityGradient_ThenDoubleVelocityGradient" begin
            # ---- GIVEN ----
            circulation = 2 / 3
            source = [1 / 7, 2 / 7]
            target = [3 / 7, 5 / 7]

            # ---- WHEN ----
            velocity_gradient_single_distance = compute_velocity_gradient(
                circulation, source, target
            )
            velocity_gradient_double_distance = compute_velocity_gradient(
                circulation, 2 * source, 2 * target
            )

            # ---- THEN ----
            @test velocity_gradient_double_distance ≈
                0.25 * velocity_gradient_single_distance
        end
    end

    @testset "Orthogonality" begin
        @testset "GivenCirculationSourceAndTarget_WhenComputeVelocityGradient_ThenOrthogonalVelocityGradientColumns" begin
            # ---- GIVEN ----
            circulation = 2 / 3
            source = [1 / 7, 2 / 7]
            target = [3 / 7, 5 / 7]

            # ---- WHEN ----
            velocity_gradient = compute_velocity_gradient(circulation, source, target)

            # ---- THEN ----
            @test isapprox(dot(velocity_gradient[:, 1], velocity_gradient[:, 2]), 0; atol=1e-12)
        end

        @testset "GivenUnitCirculationUnitHorizontalDistanceAndUnitVerticalDistance_WhenComputeVelocityGradient_ThenAbsDiagonalEqualReciprocalOfEightPi" begin
            # ---- GIVEN ----
            circulation = 1.0
            source = [1 / 7, 2 / 7]
            target = source + [1.0, 1.0]

            # ---- WHEN ----
            velocity_gradient = compute_velocity_gradient(circulation, source, target)

            # ---- THEN ----
            @test all(x -> abs(x) ≈ 1 / (8 * pi), diag(velocity_gradient))
        end
    end

    @testset "Singularity" begin
        @testset "GivenSourceEqualsTarget_WhenComputeVelocityGradient_ThenVelocityGradientEqualsNaN" begin
            # ---- GIVEN ----
            circulation = 1 / 13
            source = [0.3, 0.7]
            target = source

            # ---- WHEN ----
            velocity_gradient = compute_velocity_gradient(circulation, source, target)

            # ---- THEN ----
            @test all(x -> isnan(x), velocity_gradient)
        end
    end

    @testset "Return type" begin
        @testset "GivenFloatAndFloatVectorInputs_WhenComputeVelocityGradient_ThenReturnTypeIsConcrete" begin
            # ---- GIVEN ----
            circulation_types = (Float16, Float32, Float64)
            source_types = (Vector{x} for x in circulation_types)
            target_types = (Vector{x} for x in circulation_types)

            # ---- WHEN ---- / ---- THEN ----
            for ctype in circulation_types, stype in source_types, ttype in target_types
                @test isconcretetype(
                    Core.Compiler.return_type(
                        compute_velocity_gradient, Tuple{ctype,stype,ttype}
                    ),
                )
            end
        end

        @testset "GivenFloatAndFloatVectorInputs_WhenComputeVelocityGradient_ThenReturnTypeEqualsPromoteType" begin
            # ---- GIVEN ----
            circulation_types = (Float16, Float32, Float64)
            source_types = (Vector{x} for x in circulation_types)
            target_types = (Vector{x} for x in circulation_types)

            # ---- WHEN ---- / ---- THEN ----
            for ctype in circulation_types, stype in source_types, ttype in target_types
                @test Core.Compiler.return_type(
                    compute_velocity_gradient, Tuple{ctype,stype,ttype}
                ) == Matrix{promote_type(ctype, eltype(stype), eltype(ttype))}
            end
        end
    end
end

@testset "Vorticity" begin
    @testset "Singularity" begin
        @testset "GivenCirculationUnequalToZeroAndSourceUnequalToTarget_WhenComputeVorticity_ThenZeroVorticity" begin
            # ---- GIVEN ----
            circulation = 1 / pi
            source = [3 / pi, 5 / pi]
            target = [7 / pi, 11 / pi]

            # ---- WHEN ----
            vorticity = compute_vorticity(circulation, source, target)

            # ---- THEN ----
            @test isapprox(vorticity, 0; atol=1e-12)
        end

        @testset "GivenSourceEqualsTarget_WhenComputeVorticity_ThenVorticityEqualsNaN" begin
            # ---- GIVEN ----
            circulation = 1 / 13
            source = [0.3, 0.7]
            target = source

            # ---- WHEN ----
            vorticity = compute_vorticity(circulation, source, target)

            # ---- THEN ----
            @test isnan(vorticity)
        end
    end

    @testset "Return type" begin
        @testset "GivenFloatAndFloatVectorInputs_WhenComputeVorticity_ThenReturnTypeIsConcrete" begin
            # ---- GIVEN ----
            circulation_types = (Float16, Float32, Float64)
            source_types = (Vector{x} for x in circulation_types)
            target_types = (Vector{x} for x in circulation_types)

            # ---- WHEN ---- / ---- THEN ----
            for ctype in circulation_types, stype in source_types, ttype in target_types
                @test isconcretetype(
                    Core.Compiler.return_type(compute_vorticity, Tuple{ctype,stype,ttype})
                )
            end
        end

        @testset "GivenFloatAndFloatVectorInputs_WhenComputeVorticity_ThenReturnTypeEqualsPromoteType" begin
            # ---- GIVEN ----
            circulation_types = (Float16, Float32, Float64)
            source_types = (Vector{x} for x in circulation_types)
            target_types = (Vector{x} for x in circulation_types)

            # ---- WHEN ---- / ---- THEN ----
            for ctype in circulation_types, stype in source_types, ttype in target_types
                @test Core.Compiler.return_type(
                    compute_vorticity, Tuple{ctype,stype,ttype}
                ) == promote_type(ctype, eltype(stype), eltype(ttype))
            end
        end
    end
end

@testset "Vorticity gradient" begin
    @testset "Singularity" begin
        @testset "GivenCirculationUnequalToZeroAndSourceUnequalToTarget_WhenComputeVorticityGradient_ThenZeroVorticityGradient" begin
            # ---- GIVEN ----
            circulation = 1 / pi
            source = [3 / pi, 5 / pi]
            target = [7 / pi, 11 / pi]

            # ---- WHEN ----
            vorticity_gradient = compute_vorticity_gradient(circulation, source, target)

            # ---- THEN ----
            @test all(x -> isapprox(x, 0; atol=1e-12), vorticity_gradient)
        end

        @testset "GivenSourceEqualsTarget_WhenComputeVorticityGradient_ThenVorticityGradientEqualsNaN" begin
            # ---- GIVEN ----
            circulation = 1 / 13
            source = [0.3, 0.7]
            target = source

            # ---- WHEN ----
            vorticity_gradient = compute_vorticity_gradient(circulation, source, target)

            # ---- THEN ----
            @test all(x -> isnan(x), vorticity_gradient)
        end
    end

    @testset "Return type" begin
        @testset "GivenFloatAndFloatVectorInputs_WhenComputeVorticityGradient_ThenReturnTypeIsConcrete" begin
            # ---- GIVEN ----
            circulation_types = (Float16, Float32, Float64)
            source_types = (Vector{x} for x in circulation_types)
            target_types = (Vector{x} for x in circulation_types)

            # ---- WHEN ---- / ---- THEN ----
            for ctype in circulation_types, stype in source_types, ttype in target_types
                @test isconcretetype(
                    Core.Compiler.return_type(
                        compute_vorticity_gradient, Tuple{ctype,stype,ttype}
                    ),
                )
            end
        end

        @testset "GivenFloatAndFloatVectorInputs_WhenComputeVorticityGradient_ThenReturnTypeEqualsPromoteType" begin
            # ---- GIVEN ----
            circulation_types = (Float16, Float32, Float64)
            source_types = (Vector{x} for x in circulation_types)
            target_types = (Vector{x} for x in circulation_types)

            # ---- WHEN ---- / ---- THEN ----
            for ctype in circulation_types, stype in source_types, ttype in target_types
                @test Core.Compiler.return_type(
                    compute_vorticity_gradient, Tuple{ctype,stype,ttype}
                ) == Matrix{promote_type(ctype, eltype(stype), eltype(ttype))}
            end
        end
    end
end
