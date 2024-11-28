"""
CanMessage
"""
struct CanMessage
    cmname::String
    priority::UInt64
    dp::UInt64
    edp::UInt64
    pf::UInt64
    ps::UInt64
    sa::UInt64
    # Fixed SPNs
    fspn::Vector{UInt64}
    fspnstartbyte::Vector{UInt64}
    fspnstartbit::Vector{UInt64}
    fspnlength::Vector{UInt64}
    # SPNs
    signalnames::Vector{String}
    startbyte::Vector{UInt64}
    startbit::Vector{UInt64}
    datasize::Vector{UInt64}
    scaling::Vector{Float64}
    offset::Vector{Float64}
    # CanBus
    canbus::String
end

function CanMessage(;
    cmname = "",
    priority = 3,
    edp=0,
    dp=0,
    pf=0xFF,
    ps=0xEF,
    sa=0xFF,
    # Fixed SPNs
    fspn=[],
    fspnstartbyte=[],
    fspnstartbit=[],
    fspnlength=[],
    # SPNs
    signalnames=[],
    startbyte=[],
    startbit=[],
    datasize=[],
    scaling=[],
    offset=[],
    canbus="can0"
    )

    push!(cmsv, CanMessageStructure(cmname, priority, edp, dp, pf, ps, sa, fspn, fspnstartbyte, fspnstartbit, fspnlength,
           signalnames, startbyte, startbit, datasize, scaling, offset, canbus))
end

# Masks for parsing CAN ID (Arbitraration ID)
const PRIORITY_MASK::Int64 = 0x1C000000
const EDP_MASK::Int64 = 0x02000000
const DP_MASK::Int64 = 0x01000000
const PF_MASK::Int64 = 0x00FF0000
const PS_MASK::Int64 = 0x0000FF00
const SA_MASK::Int64 = 0x000000FF

"""
Decode a packet id into its subcomponents
"""
function decode_can_id(can_id)
    priority = (PRIORITY_MASK & can_id) >> 26
    edp = (EDP_MASK & can_id) >> 25
    dp = (can_id & PF_MASK) >> 24
    pf = (can_id & PS_MASK) >> 16
    ps = (can_id & SA_MASK)

    return priority, edp, dp, pf, ps, sa
end

"""
Encode a packet id
"""
function encode_can_id(;priority = 0x6, dp = 0x0, edp = 0x0, pf = 0x0, ps=0x0, sa=0x0)
    return(
        (priority << 26)
        + (edp << 25)
        + (dp << 24)
        + (pf << 16)
        + (ps << 8)
        + sa
    )
end

function insert_signal!(databytes, data, startbyte, startbit, datasize)

    
end

function extract_signal(databytes, startbyte, startbit, datasize)
    
    return data
end


function create_can_message(value_vec, cm::CanMessage)
    # CAN ID
    can_id = encode_can_id(priority = cm.priority, dp = cm.dp, edp = cm.edp, 
                                pf = cm.pf, ps = cm.ps, sa = cm.sa)
    # Data Bytes
    databytes = zeros(UInt64, 8)
end