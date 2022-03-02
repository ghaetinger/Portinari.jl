module PlutoD3

export D3Canvas, Line, LineScale, D3Attributes

module D3
    include("./d3_abstractions.jl")
end

include("./linear_scale.jl")
include("./line.jl")
include("./canvas.jl")

const D3Attributes = D3.D3Attributes

end # module
