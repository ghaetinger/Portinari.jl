### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 8bbbffda-f8ed-4d4a-b56b-dd0e1327e4da
using AbstractPlutoDingetjes, HypertextLiteral

# ╔═╡ a3f497e7-3b12-42c2-85cc-5d5df147833d
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ 8611bc44-b314-4967-a690-49580bba1eee
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ 188f9a3a-b6ce-475c-a45a-8c336837d744
@skip_as_script begin
	using Pkg
	using Revise
	Pkg.activate(Base.current_project(@__DIR__))
	using PlutoD3, PlutoUI
end

# ╔═╡ 96869bca-d552-4212-bb4b-969e68d0a990
@skip_as_script PlutoUI.TableOfContents()

# ╔═╡ 02c62a40-253e-49ef-8ea9-beb2cffe4196
md"# Ingredients"

# ╔═╡ b30f2165-0980-42c9-a3cf-e36033083a2a
md"# Line"

# ╔═╡ 301b949b-176f-4d84-8c2a-6c77edfb112b
md"## Curve Types"

# ╔═╡ ef6c7fdc-fbec-4aca-8bdf-f66c14aa6fd1
@enum Curve Cardinal Natural CatmullRom MonotoneX MonotoneY Basis BasisClosed

# ╔═╡ cf44495e-6bb9-456b-bcd5-a06b7b6e2d0e
md"## Structure"

# ╔═╡ 5984fc30-37d1-4e6d-beab-2233c928173d
begin
  struct Line <: D3Component
    data         :: Vector{NamedTuple{(:x, :y), Tuple{<:Real, <:Real}}}
	scaleX       :: LinearScale
	scaleY       :: LinearScale
	d3Attributes :: D3Attributes
	curveType    :: Curve
  end

  Line(x, y;
        cwidth=100,
        cheight=100,
        offset=0,
        d3Attributes=D3Attributes(),
	    curveType=Natural
  ) = Line(
	  [(x=x[i], y=y[i]) for i ∈ 1:length(x)],
	  LinearScale(x, cwidth, offset),
	  LinearScale(y, cheight, offset),
	  d3Attributes,
	  curveType
  )
end;

# ╔═╡ abec8fbc-e87e-484a-8386-f133d28eacab
md"## Javascript Snippet"

# ╔═╡ 92161843-357d-47ac-8da3-27b134b22084
Base.show(io::IO, m::MIME"text/javascript", line::Line) =
	show(io, m, @js """
    	const xScale = $(line.scaleX)();
    	const yScale = $(line.scaleY)();
    	const path = d3.line()
					   .x(d => xScale(d.x))
      				   .y(d => yScale(d.y))
      				   .curve(d3.$(line.curveType))

		const data = $(line.data);
    	s.selectAll(".line-" + id)
	     .data([data])
     	 .join("path")
     	 .transition()
	 	 .duration($(line.d3Attributes.animationTime))
     	 .attr("d", path)
     	 .attr("class", "line-" + id)
     	 $(line.d3Attributes)
	""")

# ╔═╡ a8697379-6c24-4357-909c-42d2e92798a5
Base.show(io::IO,  m::MIME"text/javascript", curve::Curve) = Base.show(io, m, HypertextLiteral.JavaScript("curve" * string(curve)))

# ╔═╡ ba53d4cc-b096-4fb8-86f3-ee8648c10cea
md"# Example"

# ╔═╡ 0b664967-afb7-4b6f-904d-0ebcc43e1b00
@skip_as_script x = collect(1:5)

# ╔═╡ 99fdeb31-01b8-4be5-bb42-fcc4f2da91ef
@skip_as_script y = [rand() for _ ∈ x]

# ╔═╡ 1a2da5d5-5908-4abd-a7bb-1fa3da814cee
@skip_as_script D3Canvas([Line(x, y;
    cwidth=300,
	cheight=300,
	offset=50,
	d3Attributes=D3Attributes(;
		attributes=Dict(
			"fill" => "none",
			"stroke" => "gold",
			"stroke-width" => "5.0"
		)
	),
	curveType=BasisClosed
)], "line_example";
	d3Attributes=D3Attributes(;
		attributes=Dict(
			"viewBox" => "0 0 300 300"
		),
		style=Dict(
			"width" => "300",
			"height" => "300"
		)
))

# ╔═╡ Cell order:
# ╠═8bbbffda-f8ed-4d4a-b56b-dd0e1327e4da
# ╟─a3f497e7-3b12-42c2-85cc-5d5df147833d
# ╟─8611bc44-b314-4967-a690-49580bba1eee
# ╟─96869bca-d552-4212-bb4b-969e68d0a990
# ╟─02c62a40-253e-49ef-8ea9-beb2cffe4196
# ╠═188f9a3a-b6ce-475c-a45a-8c336837d744
# ╟─b30f2165-0980-42c9-a3cf-e36033083a2a
# ╟─301b949b-176f-4d84-8c2a-6c77edfb112b
# ╠═ef6c7fdc-fbec-4aca-8bdf-f66c14aa6fd1
# ╠═a8697379-6c24-4357-909c-42d2e92798a5
# ╟─cf44495e-6bb9-456b-bcd5-a06b7b6e2d0e
# ╠═5984fc30-37d1-4e6d-beab-2233c928173d
# ╟─abec8fbc-e87e-484a-8386-f133d28eacab
# ╠═92161843-357d-47ac-8da3-27b134b22084
# ╟─ba53d4cc-b096-4fb8-86f3-ee8648c10cea
# ╠═0b664967-afb7-4b6f-904d-0ebcc43e1b00
# ╠═99fdeb31-01b8-4be5-bb42-fcc4f2da91ef
# ╠═1a2da5d5-5908-4abd-a7bb-1fa3da814cee
