@testitem "Default Float is consistent with system word size" begin
    # GIVEN

    expected_float_type = Sys.WORD_SIZE == 32 ? Float32 : Float64

    # WHEN

    # THEN

    @test Float == expected_float_type
end
