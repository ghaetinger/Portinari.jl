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

# ╔═╡ a766285c-9b11-11ec-0609-1b79637175d3
begin
	using Pkg
	using Revise
	Pkg.activate(Base.current_project(@__DIR__))
	using Portinari, PlutoUI, HypertextLiteral
end

# ╔═╡ 39bd54a5-6f73-43ff-b5ec-90551642741d
@bind param PlutoUI.combine() do Child
	md"""
	Width: $(Child(:width, Slider(300:10:1000; show_value=true)))  | 
	Height: $(Child(:height, Slider(300:10:1000; show_value=true)))

	Stroke Width: $(Child(:strw, Slider(1:10; show_value=true)))
	"""
end

# ╔═╡ cc8b977d-079a-4124-b9e2-c3d329cc2cd5
x = collect(1:50);

# ╔═╡ 8b7a8f64-05b2-422b-8ec5-52da5d8acb68
y = [rand() for _ ∈ x];

# ╔═╡ dc81bcdd-df79-4f23-82fc-6efefc299d46
size = [rand() * 100 for _ ∈ x];

# ╔═╡ 74185d5a-4c10-4570-a99d-44b7bed8afae
D3Canvas([
		Line(x, y;
			cwidth=param.width,
			cheight=param.height,
		    offset = 50,
			d3Attributes=D3Attributes(
				attributes=Dict(
					"fill" => "none",
					"stroke" => "gold",
					"stroke-width" => "$(param.strw)"
				)
			)
		),
		Shape(x, y, size;
		cwidth=param.width,
			cheight=param.height,
		    offset = 50,
			d3Attributes=D3Attributes(;
				attributes=Dict(
				"fill" => "none",
				"stroke" => "black"
				)
			)
		)
	], 
	"my-canvas";
	d3Attributes=D3Attributes(
		attributes=Dict("viewBox" => "0 0 $(param.width) $(param.height)"),
		style=Dict("width" => "$(param.width)px", "height" => "$(param.height)px")
	)
)

# ╔═╡ Cell order:
# ╠═a766285c-9b11-11ec-0609-1b79637175d3
# ╟─39bd54a5-6f73-43ff-b5ec-90551642741d
# ╠═cc8b977d-079a-4124-b9e2-c3d329cc2cd5
# ╠═8b7a8f64-05b2-422b-8ec5-52da5d8acb68
# ╠═dc81bcdd-df79-4f23-82fc-6efefc299d46
# ╠═74185d5a-4c10-4570-a99d-44b7bed8afae
