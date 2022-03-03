module PlutoD3

using Reexport

export Area, D3Attributes, D3Component, D3Canvas, Line, LinearScale, @js

@reexport module D3
    include("./d3_abstractions.jl")

    export @js, D3Attributes, D3Component
end

include("./linear_scale.jl")
include("./line.jl")
include("./area.jl")
include("./canvas.jl")

end # module
