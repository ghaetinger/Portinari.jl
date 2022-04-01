### A Pluto.jl notebook ###
# v0.18.4

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

# ╔═╡ a766285c-9b11-11ec-0609-1b79637175d3
begin
	using Pkg
	using Revise
	Pkg.activate(Base.current_project(@__DIR__))
	using Portinari, PlutoUI, HypertextLiteral, PlutoDevMacros
end

# ╔═╡ 8899fc63-ee2c-4fab-8826-970034b21e00
@only_in_nb x = [rand() for _ ∈ collect(1:100)]

# ╔═╡ 3b4f3edf-19e2-41a9-92cc-01d7c797c993
@only_in_nb y = [rand() for _ ∈ x]

# ╔═╡ bdc5297b-9251-49d8-aebd-ed9fd8c75526
@only_in_nb size = [rand() * rand() * 5000 for i ∈ 1:length(x)]

# ╔═╡ 5cb83977-12e1-44ba-b3c4-903a3a6e28d5
@only_in_nb @bind trievents triangles = Shape(x, y, size, "tri-id";
	d3Attributes=D3Attributes(;attributes=Dict("fill" => "rgba(255, 0, 0, 0.5)"), events=["click"]),
	shapeType=Portinari.Triangle)

# ╔═╡ 19e3bdfe-4889-4b50-a26a-434d5f3d3791
@only_in_nb @bind circleevents circles = Shape(x, y, size .* 0.5, "circle-id";
	d3Attributes=D3Attributes(;attributes=Dict("fill" => "rgba(0, 255, 0, 0.5)"), events=["click", "mouseover"]))

# ╔═╡ d4b795b2-e6b1-4f30-af27-ea3cd39b09f7
@only_in_nb md"""
# Report
#### X: $(circleevents["click"]["data"]["x"])
#### Y: $(circleevents["click"]["data"]["y"])
#### Size: $(circleevents["click"]["data"]["size"])
"""

# ╔═╡ dcdba915-fc93-4563-bb50-718a47a747c0
@only_in_nb @bind squarevents squares = Shape(x, y, size .* 0.25, "square-id";
	d3Attributes=D3Attributes(;attributes=Dict("fill" => "rgba(0, 0, 255, 0.5)"), events=["click"]),
	shapeType=Portinari.Square)

# ╔═╡ 449afb17-0fb3-4b5a-829f-d09978a673fb
@only_in_nb (trievents, circleevents, squarevents);

# ╔═╡ 2a212f8b-7a38-4d70-9a08-998887ad9d24
@only_in_nb axis_group = Axis2D(Axis(x, 500, 50, Portinari.Bottom), Axis(y, 500, 50, Portinari.Top), [triangles, circles, squares], D3Attributes(), [Portinari.zoom], "axis")

# ╔═╡ 11611800-43b3-470e-952d-cf89c4efb030
@only_in_nb @bind ev D3Canvas([axis_group], "circle_example";
	d3Attributes=D3Attributes(;
		attributes=Dict(
			"viewBox" => "0 0 600 600"
		),
		style=Dict(
			"width" => "600",
			"height" => "600"
		)
))

# ╔═╡ 89ae6bbb-81f7-4e49-ace6-d42fd9e4eeae
squarevents

# ╔═╡ Cell order:
# ╠═a766285c-9b11-11ec-0609-1b79637175d3
# ╠═8899fc63-ee2c-4fab-8826-970034b21e00
# ╠═3b4f3edf-19e2-41a9-92cc-01d7c797c993
# ╠═bdc5297b-9251-49d8-aebd-ed9fd8c75526
# ╠═d4b795b2-e6b1-4f30-af27-ea3cd39b09f7
# ╠═449afb17-0fb3-4b5a-829f-d09978a673fb
# ╠═11611800-43b3-470e-952d-cf89c4efb030
# ╠═2a212f8b-7a38-4d70-9a08-998887ad9d24
# ╠═5cb83977-12e1-44ba-b3c4-903a3a6e28d5
# ╠═89ae6bbb-81f7-4e49-ace6-d42fd9e4eeae
# ╠═19e3bdfe-4889-4b50-a26a-434d5f3d3791
# ╠═dcdba915-fc93-4563-bb50-718a47a747c0
