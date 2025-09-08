"""
    float_type([bit_size::Union{Nothing, Int}=nothing])

Returns the floating-point type (`Float32` or `Float64`) corresponding to the given `bit_size`.
If `bit_size` is not provided or is `nothing`, the function uses the system's word size to determine the type.

# Arguments
- `bit_size::Union{Nothing, Int}`: Optional. The bit size (32 or 64) to select the floating-point type. If `nothing`, uses `Sys.WORD_SIZE`.

# Returns
- `Float32` or `Float64` depending on the provided `bit_size` or system word size if `bit_size` is `nothing`.

# Throws
- `ArgumentError`: If an unsupported `bit_size` is provided.
"""
function float_type(bit_size::Union{Nothing,Int}=nothing)
    if bit_size === nothing
        word_size = Sys.WORD_SIZE
    else
        word_size = bit_size
    end

    if word_size == 32
        Float = Float32
    elseif word_size == 64
        Float = Float64
    else
        throw(ArgumentError("Unsupported word size: $(word_size)"))
    end

    return Float
end

const Float = float_type()
