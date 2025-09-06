function biot_savart_sum(induction, blobs, targets)
    result = [mapreduce(induction, +, blobs, FA.Fill(target, length(blobs))) for target in targets]
    return result
end

function biot_savart_sum(induction, blobs, target::AbstractVector{<:AbstractFloat})
    return biot_savart_sum(induction, blobs, tuple(target))
end

function biot_savart_sum(induction, blob::AbstractVortexBlob, targets)
    return biot_savart_sum(induction, tuple(blob), targets)
end

function biot_savart_sum(
    induction, blob::AbstractVortexBlob, target::AbstractVector{<:AbstractFloat}
)
    return biot_savart_sum(induction, tuple(blob), tuple(target))
end
