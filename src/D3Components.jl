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

# ╔═╡ 774bb4f2-963e-11ec-30ff-e3394f52858b
using HypertextLiteral, PlutoUI, Parameters

# ╔═╡ 0c520e27-04d5-47ff-814c-51c9dedd77e3
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ ee7cc0db-3b79-4099-b566-b673fb3744a8
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ 68e6b1f4-b0c3-4fbf-905f-454b6bf0cb8f
md"""
Need to implement js mime for components and test around to see what works
"""

# ╔═╡ aafd3c10-c0e5-48ab-81e4-b49430c5cc11
md"# Random things"

# ╔═╡ 52578854-40af-4af7-95e9-06d011615524
randstring() = String(rand(collect('a':'z'), 10))

# ╔═╡ 09e4ee53-b8b7-4de0-9439-d1bc7bc22578
md"# JS loose script"

# ╔═╡ 4d193bff-9ed2-42ba-9cef-4d8c9abc8332
esc_if_needed(x::String) = x

# ╔═╡ c9458743-0471-430e-b7a5-e26a2ccb5811
esc_if_needed(x) = esc(x)

# ╔═╡ 279012f1-b67a-4fac-a169-34dbe47e4638
begin
	struct RenderWithoutScriptTags
		x
	end

	function Base.show(io::IO, m::MIME"text/javascript", r::RenderWithoutScriptTags)
		full_result = repr(MIME"text/html"(), r.x; context=io)
		write(io, 
			"((id=0) => {" * full_result[1+length("<script>"):end-length("</script>")] * "})"
		)
	end
end

# ╔═╡ 227f7480-a39d-4692-9874-ff9328e4080a
begin
macro js_str(str_expr::Expr)
	QuoteNode(str_expr)
	quote
		result = @htl( $(Expr(:string, "<script>", esc_if_needed.(str_expr.args)..., "</script>")) )
		RenderWithoutScriptTags(result)
	end
end
macro js_str(str_expr::String)
	QuoteNode(str_expr)

	quote
		result = @htl( $(Expr(:string, "<script>", esc_if_needed(str_expr), "</script>")) )
		RenderWithoutScriptTags(result)
	end
end
end

# ╔═╡ e3156da9-8603-41f9-ad41-03eaf79c4540
md"# D3 Components"

# ╔═╡ 44721f68-c05e-4d6d-a721-6809a4ab72f8
attr_style_to_javascript(head::String, ls::Dict{String, String}) = 
	HypertextLiteral.JavaScript(
		join([".$head(\"$k\", \"$v\")" for (k, v) ∈ ls], "\n")
	)

# ╔═╡ 5b83dab0-2c5f-47d1-9a6b-1915c84b9d6c
abstract type D3Component end

# ╔═╡ 9fc986af-5532-4474-85d6-0d19399237af
begin
  struct D3ComponentID
    id :: String
  end

  D3ComponentID() = D3ComponentID(randstring())
end;

# ╔═╡ d23077cf-621f-41c8-a7c7-80b33e6e3c70
md"## Linear Scale" 

# ╔═╡ 348c15a1-1f65-4827-8d30-f636dff6b9dd
begin
  struct LinearScale{T} <: D3Component where T <: Real
    domain :: Tuple{T, T}
    range  :: Tuple{T, T}
  end
	
  function LinearScale(values::Vector{T}, range) where T <: Real
    domain = extrema(values)
	domain_type = domain |> first |> typeof
	LinearScale(domain, range |> Tuple .|> domain_type)
  end
end;

# ╔═╡ d63f33e2-0892-499c-9dc6-9a017109cc54
function Base.show(io::IO, m::MIME"text/javascript", linear_scale::LinearScale) 
show(io, m, @js_str("""
    return d3.scaleLinear()
      .domain($([linear_scale.domain...]))
      .range($([linear_scale.range...]))
"""))
end

# ╔═╡ 9099c1e2-aa63-4b87-85f3-408677e7cbad
md"## SVG Component Types"

# ╔═╡ c8ba9d49-25d1-4e52-a372-b4d3e284f769
begin
  @enum SVGComponent Path Rect Circle
  Base.show(io::IO,  m::MIME"text/javascript", svg::SVGComponent) = Base.show(io, m, svg |> Symbol |> string |> lowercase |> HypertextLiteral.JavaScript)
end

# ╔═╡ 793e2198-560d-461c-a9c4-40e042eab790
md"## D3 Attributes"

# ╔═╡ c80d5063-aac3-4ee7-994c-eb6394b225eb
@with_kw struct D3Attributes
  attributes    :: Dict{String, String} = Dict()
  style         :: Dict{String, String} = Dict()
  animationTime :: Int = 200
end

# ╔═╡ eb38a550-4002-45e7-804f-e3cc895cd4ed
md"## Line"

# ╔═╡ 993aeb91-18ce-4a36-87de-fb0387caa8d1
begin
  struct Line <: D3Component
    data   :: Vector{NamedTuple{(:x, :y), Tuple{<:Real, <:Real}}}
	scaleX :: LinearScale
	scaleY :: LinearScale
	svgComponent :: SVGComponent
	d3Attributes :: D3Attributes
  end

  Line(x, y;
        cwidth=100,
        cheight=100,
        offset=0,
        svgComponent=Path,
        d3Attributes=D3Attributes()
  ) = Line(
	  [(x=x[i], y=y[i]) for i ∈ 1:length(x)],
	  LinearScale(x, [0, cwidth] .+ offset),
	  LinearScale(y, [0, cheight] .+ offset),
	  svgComponent,
	  d3Attributes
  )
end

# ╔═╡ fc3b096e-18b3-4536-b20d-753e3ddf7082
Base.show(io::IO, m::MIME"text/javascript", line::Line) =
show(io, m, @js_str """
    const xScale = $(line.scaleX)();
    const yScale = $(line.scaleY)();
    const path = d3.line()
      .x(d => xScale(d.x))
      .y(d => yScale(d.y))
      .curve(d3.curveNatural)

	const data = $(line.data);
    s.selectAll(".line-" + id)
	 .data([data])
     .join("$(line.svgComponent)")
     .transition()
	 .duration(200)
     .attr("d", path)
     .attr("class", "line-" + id)
     $(line.d3Attributes)
""")

# ╔═╡ d544a9cc-4412-4b7d-a223-5bb181b595bb
Base.show(io::IO, m::MIME"text/javascript", d3attrs::D3Attributes) =
	Base.show(io, m, 
		attr_style_to_javascript("attr", d3attrs.attributes)
	)

# ╔═╡ 5a9b9cd0-afd9-4d41-9783-5488b0da75f2
md"# D3 Canvas"

# ╔═╡ 91f71b8a-c135-4d8c-8e86-c2aeb48ece30
begin
  struct D3Canvas
    attributes    :: Dict{String, String}
    style         :: Dict{String, String}
	width 	      :: Int64
    height        :: Int64
	id            :: String
  end
  function D3Canvas(attrs, style, width, height)
	  D3Canvas(attrs, style, width, height, randstring())
  end
end;

# ╔═╡ 501395c5-81db-493b-8e5c-1fdf8c2d86ab
md"## Paint function"

# ╔═╡ 9cd3619a-d3cd-4bf9-b0cf-c93b25d6ff9e
function paint(canvas::D3Canvas, components::Vector{<:D3Component})
@htl """
<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>
<script id="$(canvas.id)">
	const svg = this == null ? DOM.svg($(canvas.width),$(canvas.height)) : this;
	const s = this == null ? d3.select(svg) : this.s;

	var comp_foos = $components;

	for (var i = 0; i < comp_foos.length; i++) {
		comp_foos[i](i);
	}

	const output = svg
	output.s = s
	return output
</script>
"""
end

# ╔═╡ b894890a-dab0-4f39-984d-bd37c93d470b
md"## Example"

# ╔═╡ ffbc5a8f-dd1b-455c-8005-3589442dab63
@bind cwidth Slider(100:1000)

# ╔═╡ dcc56a7d-e070-4f4f-a571-1bb7fe981cdd
@bind cheight Slider(100:1000)

# ╔═╡ fa58813a-abdf-4ca2-965a-6b600fbd85c6
@skip_as_script x = collect(1:100)

# ╔═╡ dcdd477b-729c-4e34-9da8-19d702ee7920
@skip_as_script y = [rand() for _ ∈ 1:100]

# ╔═╡ 06924b38-26df-47fd-98c5-838b623e9039
canvas = D3Canvas(Dict(), Dict(), 1000, 1000)

# ╔═╡ d4bd2b90-9450-4c51-993d-ee0ba75d0167
paint(canvas, [
	Line(x, y;
	cwidth=cwidth,
	cheight=cheight,
	d3Attributes=D3Attributes(
		attributes=Dict("stroke" => "pink", "fill" => "none", "stroke-width" => "2.5")
	)),
Line(x, y;
	cwidth=cwidth,
	cheight=cheight,
	d3Attributes=D3Attributes(
		attributes=Dict("stroke" => "black", "fill" => "none")
))
])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.3"
Parameters = "~0.12.3"
PlutoUI = "~0.7.35"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "13468f237353112a01b2d6b32f3d0f80219944aa"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "85bf3e4bd279e405f91489ce518dedb1e32119cb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.35"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─0c520e27-04d5-47ff-814c-51c9dedd77e3
# ╟─ee7cc0db-3b79-4099-b566-b673fb3744a8
# ╠═774bb4f2-963e-11ec-30ff-e3394f52858b
# ╠═68e6b1f4-b0c3-4fbf-905f-454b6bf0cb8f
# ╟─aafd3c10-c0e5-48ab-81e4-b49430c5cc11
# ╟─52578854-40af-4af7-95e9-06d011615524
# ╟─09e4ee53-b8b7-4de0-9439-d1bc7bc22578
# ╠═4d193bff-9ed2-42ba-9cef-4d8c9abc8332
# ╠═c9458743-0471-430e-b7a5-e26a2ccb5811
# ╠═279012f1-b67a-4fac-a169-34dbe47e4638
# ╠═227f7480-a39d-4692-9874-ff9328e4080a
# ╟─e3156da9-8603-41f9-ad41-03eaf79c4540
# ╠═44721f68-c05e-4d6d-a721-6809a4ab72f8
# ╠═5b83dab0-2c5f-47d1-9a6b-1915c84b9d6c
# ╠═9fc986af-5532-4474-85d6-0d19399237af
# ╟─d23077cf-621f-41c8-a7c7-80b33e6e3c70
# ╠═348c15a1-1f65-4827-8d30-f636dff6b9dd
# ╠═d63f33e2-0892-499c-9dc6-9a017109cc54
# ╟─9099c1e2-aa63-4b87-85f3-408677e7cbad
# ╠═c8ba9d49-25d1-4e52-a372-b4d3e284f769
# ╟─793e2198-560d-461c-a9c4-40e042eab790
# ╠═c80d5063-aac3-4ee7-994c-eb6394b225eb
# ╠═d544a9cc-4412-4b7d-a223-5bb181b595bb
# ╟─eb38a550-4002-45e7-804f-e3cc895cd4ed
# ╠═993aeb91-18ce-4a36-87de-fb0387caa8d1
# ╠═fc3b096e-18b3-4536-b20d-753e3ddf7082
# ╟─5a9b9cd0-afd9-4d41-9783-5488b0da75f2
# ╠═91f71b8a-c135-4d8c-8e86-c2aeb48ece30
# ╟─501395c5-81db-493b-8e5c-1fdf8c2d86ab
# ╠═9cd3619a-d3cd-4bf9-b0cf-c93b25d6ff9e
# ╟─b894890a-dab0-4f39-984d-bd37c93d470b
# ╠═ffbc5a8f-dd1b-455c-8005-3589442dab63
# ╠═dcc56a7d-e070-4f4f-a571-1bb7fe981cdd
# ╠═fa58813a-abdf-4ca2-965a-6b600fbd85c6
# ╠═dcdd477b-729c-4e34-9da8-19d702ee7920
# ╠═d4bd2b90-9450-4c51-993d-ee0ba75d0167
# ╠═06924b38-26df-47fd-98c5-838b623e9039
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
