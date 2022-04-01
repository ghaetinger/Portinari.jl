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

# ╔═╡ 2f76b33d-fa26-4b3d-9d78-78cc65e99b7e
using AbstractPlutoDingetjes, HypertextLiteral, Parameters, PlutoUI, PlutoDevMacros

# ╔═╡ f6a506e8-23ae-4a5b-842d-f938cfceee5f
@only_in_nb PlutoUI.TableOfContents()

# ╔═╡ 796ed4ef-66b8-4c03-a0d2-429cc3ac76eb
md"# Ingredients"

# ╔═╡ 40896e22-e6a0-4dfb-b202-9764de200d79
@plutoinclude "./context.jl" "all"

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
  struct Area <: D3Component
    data         :: Vector{NamedTuple{(:x, :y0, :y1), Tuple{<:Real, <:Real, <:Real}}}
	d3Attributes :: D3Attributes
	curveType    :: Curve
	id           :: String
  end

  Area(x::Vector{}, y0::Vector{}, y1::Vector{}, id::String;
	d3Attributes=D3Attributes(),
	curveType=Natural
  ) = Area(
	  [(x=x[i], y0=y0[i], y1=y1[i]) for i ∈ 1:length(x)],
	  d3Attributes,
	  curveType,
	  id
  )
end;

# ╔═╡ b7c8ca6e-bec8-43a7-a3c9-8ad09d017e5e
function bounds(area::Area)
	xs = (v -> v.x).(data)
	ys = reduce(vcat, (v -> [v.y0, v.y1]).(data)) 
	return (minx=minimum(xs), miny=minimum(ys), maxx=maximum(xs), maxy=maximum(ys))
end

# ╔═╡ f1e2da3f-71b2-48a1-a51b-cd1ae6fac89c
md"## Javascript Snippet"

# ╔═╡ 1d601e35-6cac-4473-b476-9fc4aa320937
Base.show(io::IO, m::MIME"text/javascript", area::Area) =
	show(io, m, @js """
	    const span = document.getElementById($(area.id));
		span.value = span.value || {};
		span.dispatchEvent(new CustomEvent("input"));

		xScale = xScale || $(Axis((x->x.x).(area.data), [50, 250], Bottom))(s)[0];
		yScale = yScale || $(Axis((x->x.y1).(area.data), [50, 250], Left))(s)[0];
	
    	const path = d3.area()
					   .x(d => xScale(d.x))
      				   .y0(d => yScale(d.y0))
      				   .y1(d => yScale(d.y1))
      				   .curve(d3.$(area.curveType))

		const data = $(area.data);
    	s.selectAll(".area-" + id)
	     .data([data])
     	 .join("path")
     	 $(area.d3Attributes)
     	 .attr("d", path)
     	 .attr("class", "area-" + id)
	""")

# ╔═╡ c0fda2f7-a893-496c-8798-3a84a0c92d5a
Base.show(io::IO, m::MIME"text/html", area::Area) =	show(io, m, @htl("""
	<span id=$(area.id)>
	<script id="preview-$(area.id)">

	const { d3 } = $(import_local_js(d3_import));

	const svg = this == null ? DOM.svg(300, 300) : this;
	const s = this == null ? d3.select(svg) : this.s;

	var xScale, yScale;
	
	$(area)(s, 0, currentScript.parentElement);

	const output = svg
	output.s = s
	return output
	</script>
	</span>
"""))

# ╔═╡ c9bed508-ea77-4ae4-8876-ac2a5ec62114
Base.show(io::IO,  m::MIME"text/javascript", curve::Curve) = Base.show(io, m, HypertextLiteral.JavaScript("curve" * string(curve)))

# ╔═╡ 354f2549-8d20-4ac3-a6f0-5acf1ad4fde4
md"# Example"

# ╔═╡ 12ac3f7f-c1a4-4575-b7f8-82684175b921
@only_in_nb x = collect(1:5)

# ╔═╡ 05b7122e-96fe-479c-a7a8-a6070e93d775
@only_in_nb y = [rand() for _ ∈ x]

# ╔═╡ b76623bc-53a6-4a90-b11b-266d1caac640
@only_in_nb @bind areaevents area = Area(x, y, y .* 2, "area-id"; d3Attributes=D3Attributes(events=["mouseover"]))

# ╔═╡ 9f2fd77e-1810-4f1a-891b-b2e460e8489a
@only_in_nb D3Canvas([area], "area_example"; d3Attributes=D3Attributes(;
	attributes=Dict(
		"viewBox" => "0 0 300 300"
	),
	style=Dict(
		"width" => "300",
		"height" => "300"
	)
))

# ╔═╡ ef8033bd-27e3-45bf-acc7-330f40ec144a
@only_in_nb areaevents["mouseover"]["count"]

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractPlutoDingetjes = "~1.1.4"
HypertextLiteral = "~0.9.3"
Parameters = "~0.12.3"
PlutoDevMacros = "~0.4.5"
PlutoUI = "~0.7.37"
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

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

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
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoDevMacros]]
deps = ["MacroTools", "Requires"]
git-tree-sha1 = "994167def8f46d3be21783a76705228430e29632"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.4.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

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

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

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
# ╠═f6a506e8-23ae-4a5b-842d-f938cfceee5f
# ╟─796ed4ef-66b8-4c03-a0d2-429cc3ac76eb
# ╠═2f76b33d-fa26-4b3d-9d78-78cc65e99b7e
# ╠═40896e22-e6a0-4dfb-b202-9764de200d79
# ╟─93ede436-8e57-4030-93ae-74567844f624
# ╟─a6ef4beb-dd0d-4517-8382-30bbdfb685cc
# ╠═3bf51d0b-5d80-4321-9ecb-6680c70fffec
# ╠═c9bed508-ea77-4ae4-8876-ac2a5ec62114
# ╟─73005a4c-7d7a-41b6-ad8c-52780d51f24c
# ╠═6a107d2b-96db-465a-8582-0c6ab5699043
# ╠═b7c8ca6e-bec8-43a7-a3c9-8ad09d017e5e
# ╟─f1e2da3f-71b2-48a1-a51b-cd1ae6fac89c
# ╠═1d601e35-6cac-4473-b476-9fc4aa320937
# ╠═c0fda2f7-a893-496c-8798-3a84a0c92d5a
# ╟─354f2549-8d20-4ac3-a6f0-5acf1ad4fde4
# ╠═12ac3f7f-c1a4-4575-b7f8-82684175b921
# ╠═05b7122e-96fe-479c-a7a8-a6070e93d775
# ╠═b76623bc-53a6-4a90-b11b-266d1caac640
# ╠═9f2fd77e-1810-4f1a-891b-b2e460e8489a
# ╠═ef8033bd-27e3-45bf-acc7-330f40ec144a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
