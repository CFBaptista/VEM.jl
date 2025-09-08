@testitem "Default Float is consistent with system word size" begin
    # GIVEN

    expected_float_type = Sys.WORD_SIZE == 32 ? Float32 : Float64

    # WHEN

    float_type = VEM.float_type()

    # THEN

    @test float_type == expected_float_type
end

@testitem "32 bit size returns Float32" begin
    # GIVEN

    bit_size = 32
    expected_float_type = Float32

    # WHEN

    float_type = VEM.float_type(bit_size)

    # THEN

    @test float_type == expected_float_type
end

@testitem "64 bit size returns Float64" begin
    # GIVEN

    bit_size = 64
    expected_float_type = Float64

    # WHEN

    float_type = VEM.float_type(bit_size)

    # THEN

    @test float_type == expected_float_type
end

@testitem "128 bit size throws error" begin
    # GIVEN

    bit_size = 128

    # WHEN / THEN

    @test_throws ArgumentError VEM.float_type(bit_size)
end
