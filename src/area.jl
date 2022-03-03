### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 2f76b33d-fa26-4b3d-9d78-78cc65e99b7e
using AbstractPlutoDingetjes, HypertextLiteral

# ╔═╡ f395d700-9616-4c0a-85c5-7f0d16816734
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ 51f59429-25e3-4774-b9bb-b8d2856d5256
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ 086e3945-38da-4f91-8e54-d67702c2dd3c
@skip_as_script begin
	using Pkg
	using Revise
	Pkg.activate(Base.current_project(@__DIR__))
	using PlutoD3, PlutoUI
end

# ╔═╡ f6a506e8-23ae-4a5b-842d-f938cfceee5f
@skip_as_script PlutoUI.TableOfContents()

# ╔═╡ 796ed4ef-66b8-4c03-a0d2-429cc3ac76eb
md"# Ingredients"

# ╔═╡ 93ede436-8e57-4030-93ae-74567844f624
md"# Area"

# ╔═╡ a6ef4beb-dd0d-4517-8382-30bbdfb685cc
md"## Curve Types"

# ╔═╡ 3bf51d0b-5d80-4321-9ecb-6680c70fffec
@enum Curve Cardinal Natural CatmullRom MonotoneX MonotoneY Basis BasisClosed

# ╔═╡ 73005a4c-7d7a-41b6-ad8c-52780d51f24c
md"## Structure"

# ╔═╡ 6a107d2b-96db-465a-8582-0c6ab5699043
begin
  struct Area <: D3.D3Component
    data         :: Vector{NamedTuple{(:x, :y0, :y1), Tuple{<:Real, <:Real, <:Real}}}
	scaleX       :: LinearScale
	scaleY       :: LinearScale
	d3Attributes :: D3.D3Attributes
	curveType    :: Curve
  end

  Area(x, y0, y1;
        cwidth=100,
        cheight=100,
        offset=0,
        d3Attributes=D3.D3Attributes(),
	    curveType=Natural
  ) = Area(
	  [(x=x[i], y0=y0[i], y1=y1[i]) for i ∈ 1:length(x)],
	  LinearScale(x, cwidth, offset),
	  LinearScale(y1, cheight, offset),
	  d3Attributes,
	  curveType
  )
end;

# ╔═╡ f1e2da3f-71b2-48a1-a51b-cd1ae6fac89c
md"## Javascript Snippet"

# ╔═╡ 1d601e35-6cac-4473-b476-9fc4aa320937
Base.show(io::IO, m::MIME"text/javascript", area::Area) =
	show(io, m, D3.@js """
    	const xScale = $(area.scaleX)();
    	const yScale = $(area.scaleY)();
    	const path = d3.area()
					   .x(d => xScale(d.x))
      				   .y0(d => yScale(d.y0))
      				   .y1(d => yScale(d.y1))
      				   .curve(d3.$(area.curveType))

		const data = $(area.data);
    	s.selectAll(".line-" + id)
	     .data([data])
     	 .join("path")
     	 .transition()
	 	 .duration($(area.d3Attributes.animationTime))
     	 .attr("d", path)
     	 .attr("class", "line-" + id)
     	 $(area.d3Attributes)
	""")

# ╔═╡ c9bed508-ea77-4ae4-8876-ac2a5ec62114
Base.show(io::IO,  m::MIME"text/javascript", curve::Curve) = Base.show(io, m, HypertextLiteral.JavaScript("curve" * string(curve)))

# ╔═╡ 354f2549-8d20-4ac3-a6f0-5acf1ad4fde4
md"# Example"

# ╔═╡ 12ac3f7f-c1a4-4575-b7f8-82684175b921
@skip_as_script x = collect(1:5)

# ╔═╡ 05b7122e-96fe-479c-a7a8-a6070e93d775
@skip_as_script y = [rand() for _ ∈ x]

# ╔═╡ 9f2fd77e-1810-4f1a-891b-b2e460e8489a
@skip_as_script D3Canvas([Area(x, y, y .* 2;
    cwidth=300,
	cheight=300,
	offset=50,
	d3Attributes=D3Attributes(;
		attributes=Dict(
			"fill" => "orange",
			"stroke" => "gold",
			"stroke-width" => "5.0"
		)
	)
)], "area_example"; d3Attributes=D3Attributes(;
	attributes=Dict(
		"viewBox" => "0 0 300 300"
	),
	style=Dict(
		"width" => "300",
		"height" => "300"
	)
))

# ╔═╡ Cell order:
# ╠═2f76b33d-fa26-4b3d-9d78-78cc65e99b7e
# ╟─f395d700-9616-4c0a-85c5-7f0d16816734
# ╟─51f59429-25e3-4774-b9bb-b8d2856d5256
# ╟─f6a506e8-23ae-4a5b-842d-f938cfceee5f
# ╟─796ed4ef-66b8-4c03-a0d2-429cc3ac76eb
# ╠═086e3945-38da-4f91-8e54-d67702c2dd3c
# ╟─93ede436-8e57-4030-93ae-74567844f624
# ╠═a6ef4beb-dd0d-4517-8382-30bbdfb685cc
# ╠═3bf51d0b-5d80-4321-9ecb-6680c70fffec
# ╠═c9bed508-ea77-4ae4-8876-ac2a5ec62114
# ╟─73005a4c-7d7a-41b6-ad8c-52780d51f24c
# ╠═6a107d2b-96db-465a-8582-0c6ab5699043
# ╠═f1e2da3f-71b2-48a1-a51b-cd1ae6fac89c
# ╠═1d601e35-6cac-4473-b476-9fc4aa320937
# ╟─354f2549-8d20-4ac3-a6f0-5acf1ad4fde4
# ╠═12ac3f7f-c1a4-4575-b7f8-82684175b921
# ╠═05b7122e-96fe-479c-a7a8-a6070e93d775
# ╠═9f2fd77e-1810-4f1a-891b-b2e460e8489a
