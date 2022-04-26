### A Pluto.jl notebook ###
# v0.18.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 40ce97fc-aed8-11ec-381d-39c142fc0c6b
begin
	using Pkg
	using Revise
	Pkg.activate(Base.current_project(@__DIR__))
	using Portinari, PlutoUI, HypertextLiteral, PlutoDevMacros
end

# ╔═╡ a8a51537-c5c9-4f88-8c0b-3eb8d5a3c85d
@bind sz Slider(1:100; default=10)

# ╔═╡ 27d8844f-48fd-4daa-a9fd-97fb1ee088f7
x = rand(sz)

# ╔═╡ 0c9f5641-b917-422d-abd6-ae3b3d1ed0cf
y = rand(sz)

# ╔═╡ d2a0eb54-5962-4df2-92dd-b47f3cf4b0c1
y2 = [v^2 for v ∈ y]

# ╔═╡ 6abb5eef-6400-48b2-b526-f5e5a3ae44af
@bind lineevents line = Line(x, y, "lineid"; d3Attributes=D3Attributes(
	style=Dict(
		"fill" => "none",
		"stroke" => "green",
		"stroke-width" => "6px"
	),
	events=["click"]
),curveType=Portinari.BasisClosed)

# ╔═╡ a19dd476-b70e-4847-9f40-15f9f5715262
@bind events circles = Shape(x, y, y2 .* 1000, "shapes"; d3Attributes=D3Attributes(attributes=Dict("fill" => "rgba(0, 100, 255, 0.3)"), events=["click", "mouseover"]))

# ╔═╡ 3984e4f8-a172-48dc-a135-5ad8d8c6244d
md"""
# Report
###### X: $(events["click"]["data"]["x"])
###### Y: $(events["click"]["data"]["y"])
###### Size: $(events["click"]["data"]["size"])
###### Mouseover size! $(events["mouseover"]["data"]["size"])
"""

# ╔═╡ a4ac8702-c21e-41b0-8d60-ebff0b680214
axis = Axis2D(Axis(x, 400, 50, Portinari.Bottom; show=true), Axis(y, 500, 50, Portinari.Right; show=true), [line, circles], D3Attributes(style=Dict("width" => "600px", "height" => "600px")), [Portinari.zoom], "id")

# ╔═╡ a5648729-28cf-4296-9490-2f07d50720e5
D3Canvas([axis, line], "canv"; d3Attributes=D3Attributes(style=Dict("width" => "600px", "height" => "600px"), attributes=Dict("viewBox" => "0 0 600 600")))

# ╔═╡ Cell order:
# ╠═40ce97fc-aed8-11ec-381d-39c142fc0c6b
# ╠═27d8844f-48fd-4daa-a9fd-97fb1ee088f7
# ╠═0c9f5641-b917-422d-abd6-ae3b3d1ed0cf
# ╟─d2a0eb54-5962-4df2-92dd-b47f3cf4b0c1
# ╟─6abb5eef-6400-48b2-b526-f5e5a3ae44af
# ╠═a19dd476-b70e-4847-9f40-15f9f5715262
# ╟─3984e4f8-a172-48dc-a135-5ad8d8c6244d
# ╟─a8a51537-c5c9-4f88-8c0b-3eb8d5a3c85d
# ╠═a5648729-28cf-4296-9490-2f07d50720e5
# ╠═a4ac8702-c21e-41b0-8d60-ebff0b680214
