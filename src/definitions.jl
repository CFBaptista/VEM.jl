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
