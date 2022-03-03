### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ e1f13b19-423b-41ff-82cf-792d804f4b18
using AbstractPlutoDingetjes, HypertextLiteral

# ╔═╡ bf7c59c3-6cc4-4f81-ac35-7dd5992525a6
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ 496d803a-cbce-4b5f-a77a-3b5d911dc632
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ 6dad98d2-339b-479e-9dba-920dc2f11538
@skip_as_script begin
	using Pkg
	using Revise
	Pkg.activate(Base.current_project(@__DIR__))
	using PlutoD3, PlutoUI
end

# ╔═╡ 7d020640-6e54-4725-92fa-a07ba258e7cf
@skip_as_script PlutoUI.TableOfContents()

# ╔═╡ 537b9d39-5244-43f4-96e7-4fa99c8c6892
md"# Ingredients"

# ╔═╡ e7779bec-c6cb-4d64-bfc0-74d9c558fe28
md"# Linear Scale"

# ╔═╡ 762847fa-0710-4973-adcf-697ccd245df4
md"## Position"

# ╔═╡ bd8f5ee1-dc2a-4336-9b70-dfe4277210d9
@enum Direction Top Bottom Left Right

# ╔═╡ df99d778-abb1-4cfa-a576-f76394b4ac9e
Base.show(io::IO, m::MIME"text/javascript", pos::Direction) =
	show(io, m, HypertextLiteral.JavaScript("axis"  * string(pos)))

# ╔═╡ ac43922e-c65f-4dd3-9596-6c68c57fa5d4
md"## Structure"

# ╔═╡ 7077ff40-8dd1-43ba-9d4f-c1d905e40fee
begin
  struct LinearScale{T<:Real} <: D3Component
    domain :: Tuple{T, T}
    range  :: Tuple{T, T}
	show   :: Bool
	dir    :: Direction
	pos    :: NamedTuple{(:x, :y), Tuple{Int64, Int64}}
  end
	
  function LinearScale(values::Vector{T}, range;
  	show=false, dir=Bottom, pos=(x=0, y=0)
  ) where T <: Real
    domain = extrema(values)
	LinearScale(domain, range |> Tuple .|> T, show, dir, pos)
  end

  function LinearScale(values::Vector{<:Real}, size::T, offset::T; show=false, dir=Bottom, pos=(x=0, y=0)) where T <: Real
	  LinearScale(values, [offset, size-offset]; show=show, dir=dir, pos=pos)
  end
end;

# ╔═╡ ce989e07-8317-4747-8ce5-84f0a123b8f0
md"## Javascript Snippet"

# ╔═╡ 8f883397-2167-48fc-b826-0367d294d573
function Base.show(io::IO, m::MIME"text/javascript", linear_scale::LinearScale) 
show(io, m, @js("""
    const scale = d3.scaleLinear()
      .domain($([linear_scale.domain...]))
      .range($([linear_scale.range...]))

	if ($(linear_scale.show)) {
		var axis = d3.$(linear_scale.dir)()
                     .scale(scale)

		s.selectAll(".axis-" + id)
         .data([1])
         .join("g")
		 .attr("class", "axis-" + id)
		 .style("transform", 
                "translate($(linear_scale.pos.x)px, $(linear_scale.pos.y)px)")
         .call(axis)
	}

    return scale
"""))
end

# ╔═╡ Cell order:
# ╠═e1f13b19-423b-41ff-82cf-792d804f4b18
# ╟─bf7c59c3-6cc4-4f81-ac35-7dd5992525a6
# ╟─496d803a-cbce-4b5f-a77a-3b5d911dc632
# ╠═7d020640-6e54-4725-92fa-a07ba258e7cf
# ╟─537b9d39-5244-43f4-96e7-4fa99c8c6892
# ╠═6dad98d2-339b-479e-9dba-920dc2f11538
# ╟─e7779bec-c6cb-4d64-bfc0-74d9c558fe28
# ╟─762847fa-0710-4973-adcf-697ccd245df4
# ╠═bd8f5ee1-dc2a-4336-9b70-dfe4277210d9
# ╠═df99d778-abb1-4cfa-a576-f76394b4ac9e
# ╟─ac43922e-c65f-4dd3-9596-6c68c57fa5d4
# ╠═7077ff40-8dd1-43ba-9d4f-c1d905e40fee
# ╟─ce989e07-8317-4747-8ce5-84f0a123b8f0
# ╠═8f883397-2167-48fc-b826-0367d294d573
