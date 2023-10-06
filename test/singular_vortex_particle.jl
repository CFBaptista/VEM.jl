using LinearAlgebra
using Test
using VEM

@testset "Symmetries" begin
    @testset "GivenTranslationOfOrigin_WhenComputeVelocity_ThenSameVelocity" begin
        # ---- GIVEN ----
        circulation = 1.0
        source = [0.0, 0.0]
        target = [1.0, 0.0]

        translation = [1.0, 1.0]
        translated_source = source - translation
        translated_target = target - translation

        # ---- WHEN ----
        velocity_without_translation = compute_velocity(circulation, source, target)
        velocity_with_translation = compute_velocity(
            circulation, translated_source, translated_target
        )

        # ---- THEN ----
        @test velocity_without_translation == velocity_with_translation
    end

    @testset "GivenRotationOfOrigin_WhenComputeVelocity_ThenSameSpeed" begin
        # ---- GIVEN ----
        circulation = 1.0
        source = [1.0, 0.5]
        target = [0.75, 0.75]

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
        circulation = 1.0
        source = [0.0, 0.0]
        target = [1.0, 0.0]

        # ---- WHEN ----
        velocity_without_switch = compute_velocity(circulation, source, target)
        velocity_with_switch = compute_velocity(circulation, target, source)

        # ---- THEN ----
        @test velocity_without_switch == -velocity_with_switch
    end
end

@testset "Singularity" begin
    @testset "GivenSourceEqualsTarget_WhenComputeVelocity_ThenVelocityEqualsNaN" begin
        # ---- GIVEN ----
        circulation = 1.0
        source = [0.5, 0.5]
        target = source

        # ---- WHEN ----
        velocity = compute_velocity(circulation, source, target)

        # ---- THEN ----
        @test all(x -> isnan(x), velocity)
    end
end

@testset "Orthogonality" begin
    @testset "GivenCirculationSourceAndTarget_WhenComputeVelocity_ThenVelocityPerpendicularToDistance" begin
        # ---- GIVEN ----
        circulation = 1.0
        source = [0.25, 0.75]
        target = [0.75, 0.25]

        # ---- WHEN ----
        velocity = compute_velocity(circulation, source, target)

        # ---- THEN ----
        @test dot(target - source, velocity) ≈ 0.0
    end
end

@testset "Proportionality" begin
    @testset "GivenDoubleCirculation_WhenComputeVelocity_ThenDoubleVelocity" begin
        # ---- GIVEN ----
        circulation = 3.0
        source = [0.25, 0.75]
        target = [0.75, 0.25]

        # ---- WHEN ----
        velocity_single_circulation = compute_velocity(circulation, source, target)
        velocity_double_circulation = compute_velocity(2 * circulation, source, target)

        # ---- THEN ----
        @test velocity_double_circulation == 2 * velocity_single_circulation
    end

    @testset "GivenDoubleDistance_WhenComputeVelocity_ThenHalfVelocity" begin
        # ---- GIVEN ----
        circulation = 3.0
        source = [0.25, 0.75]
        target = [0.75, 0.25]

        # ---- WHEN ----
        velocity_single_distance = compute_velocity(circulation, source, target)
        velocity_double_distance = compute_velocity(circulation, 2 * source, 2 * target)

        # ---- THEN ----
        @test velocity_double_distance == 0.5 * velocity_single_distance
    end

    @testset "GivenUnitCirculationAndUnitDistance_WhenComputeVelocity_ThenSpeedEqualsReciprocalOfTwoPi" begin
        # ---- GIVEN ----
        circulation = 1.0
        source = [0.0, 1.0]
        target = [0.0, 2.0]

        # ---- WHEN ----
        velocity = compute_velocity(circulation, source, target)

        # ---- THEN ----
        @test norm(velocity) == 1 / (2 * pi)
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
            @test Core.Compiler.return_type(compute_velocity, Tuple{ctype,stype,ttype}) ==
                Vector{promote_type(ctype, eltype(stype), eltype(ttype))}
        end
    end
end
