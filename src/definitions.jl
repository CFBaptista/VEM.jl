"""
    Float

Default floating-point type (`Float32` or `Float64`) corresponding to the system's word size.
"""
const Float = Sys.WORD_SIZE == 32 ? Float32 : Float64
