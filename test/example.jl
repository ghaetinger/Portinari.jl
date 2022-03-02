### A Pluto.jl notebook ###
# v0.18.1

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

# ╔═╡ 8c91a16a-9a3c-11ec-2d66-e5b70965ccdd
begin
	using Pkg
	using Revise
	Pkg.activate(Base.current_project(@__DIR__))
	using PlutoD3, PlutoUI, HypertextLiteral
end

# ╔═╡ 033d82ef-fd56-46e9-8199-c0222614c341
x = collect(1:10)

# ╔═╡ 2c7f409d-f52b-427f-a06f-7c3d0935aa54
y = [rand() for _ ∈ x]

# ╔═╡ 0652b983-8fb1-4c1c-99ac-fddddd26ec76
@bind w Slider(100:1000)

# ╔═╡ 10159f1a-d5a8-4cf4-986b-2666e711df80
@bind h Slider(100:1000)

# ╔═╡ 9de66973-ea7d-4df9-9b32-cd87c475d28c
canvas = D3Canvas([
	Line(x, y;
	cwidth = w,
	cheight = h,
	offset = round(Int64, min(w, h) / 10),
	d3Attributes=D3Attributes(;
		attributes=Dict(
			"fill" => "green",
			"stroke" => "gold",
			"stroke-width" => "7.0"
		)
	),
	curveType=PlutoD3.BasisClosed
	),
	Area(x, y, y .* 2; 
	cwidth = w,
	cheight = h,
	offset =round(Int64, min(w, h) / 10),
	d3Attributes=D3Attributes(;
		attributes=Dict(
			"fill" => "rgba(0, 0, 255, 0.4)",
			"stroke" => "none",
			"stroke-width" => "1.0"
		),
		style=Dict(
			"filter" => "blur(1px)"
		)
	),
		curveType=PlutoD3.Basis
	)
], "abc"; d3Attributes=D3Attributes(;
		attributes=Dict(
			"viewBox" => "0 0 $w $h"
		),
		style=Dict(
			"width" => "$(w)px",
			"height" => "$(h)px",
		)
	))

# ╔═╡ 37b63783-56d8-4176-beb2-799240370f33
canvas

# ╔═╡ e2a61f90-9a47-4f59-8c6c-f3cff087fa4e
const Layout = PlutoUI.ExperimentalLayout

# ╔═╡ Cell order:
# ╠═8c91a16a-9a3c-11ec-2d66-e5b70965ccdd
# ╠═033d82ef-fd56-46e9-8199-c0222614c341
# ╠═2c7f409d-f52b-427f-a06f-7c3d0935aa54
# ╠═0652b983-8fb1-4c1c-99ac-fddddd26ec76
# ╠═10159f1a-d5a8-4cf4-986b-2666e711df80
# ╠═37b63783-56d8-4176-beb2-799240370f33
# ╠═9de66973-ea7d-4df9-9b32-cd87c475d28c
# ╠═e2a61f90-9a47-4f59-8c6c-f3cff087fa4e
