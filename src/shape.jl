### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 48c1bb3e-7a28-4784-bc2a-64b19bd58b49
using AbstractPlutoDingetjes, HypertextLiteral, Parameters, PlutoUI, PlutoDevMacros

# ╔═╡ 56c9d966-382d-4c31-95ae-3af31be8e319
@only_in_nb PlutoUI.TableOfContents()

# ╔═╡ e1ba78ff-a168-4a07-8b08-0299f83bc70f
md"# Ingredients"

# ╔═╡ a084c49d-b1de-4033-93be-6d747cc66696
@plutoinclude "./linear_scale.jl" "all"

# ╔═╡ f956d529-3001-4488-9898-db01aa6add73
md"# Shape"

# ╔═╡ 5ae0cf49-aa13-4681-b9d1-0383cd39d8f1
md"## Types"

# ╔═╡ e00085a9-8fc3-4205-8037-b9ddb7090862
@enum ShapeType Square Circle Triangle

# ╔═╡ 5e895427-8660-44b2-8639-f0f3d701265d
md"## Structure"

# ╔═╡ 3dbad6fc-e54e-49ee-a5f2-31ace0581812
begin
  struct Shape <: D3Component
    data         :: Vector{NamedTuple{(:x, :y, :size), Tuple{<:Real, <:Real, <:Real}}}
	scaleX       :: LinearScale
	scaleY       :: LinearScale
	d3Attributes :: D3Attributes
	shapeType    :: ShapeType
  end
	

  Shape(x, y, size;
        cwidth=100,
        cheight=100,
        offset=0,
        d3Attributes=D3Attributes(),
	    shapeType=Circle
  ) = Shape(
	  [(x=x[i], y=y[i], size=size[i]) for i ∈ 1:length(x)],
	  LinearScale(x, cwidth, offset),
	  LinearScale(y, cheight, offset),
	  d3Attributes,
	  shapeType
  )
end;

# ╔═╡ 3caffb89-d565-43b0-85ae-3a431d378f67
md"## Javascript Snippet"

# ╔═╡ 3d5b3b66-70d6-4ee7-b87d-e95f5fbe884a
function Base.show(io::IO, m::MIME"text/javascript", shape::Shape)
	show(io, m, @js """
    	const xScale = $(shape.scaleX)();
    	const yScale = $(shape.scaleY)();
		const symbol = d3.symbol()
	                     .type($(shape.shapeType))
	                     .size(d => d.size);
	
		const data = $(shape.data);
    	s.selectAll(".shape-" + id)
	     .data(data)
     	 .join("path")
     	 .transition()
	 	 .duration($(shape.d3Attributes.animationTime))
		 .attr("transform", d => "translate(" + xScale(d.x) + "," + yScale(d.y) + ")")
	     .attr("d", symbol)
     	 .attr("class", "shape-" + id)
     	 $(shape.d3Attributes)
	"""
	)
end

# ╔═╡ 59af5f8a-8383-4d3e-bc9b-39a99769515e
Base.show(io::IO,  m::MIME"text/javascript", shapeType::ShapeType) = Base.show(io, m, HypertextLiteral.JavaScript("d3.symbol" * (string(shapeType))))

# ╔═╡ e3c572e1-f4df-4b55-8ada-2221cffca8a7
md"# Example"

# ╔═╡ 231107ce-cdc2-413f-91d0-5df25124d9b6
@only_in_nb x = collect(1:5)

# ╔═╡ 75adb70c-1cb0-4dd3-8ee4-a054e32094c9
@only_in_nb y = [rand() for _ ∈ x]

# ╔═╡ 55930668-9a5d-4352-bfac-1332355f3afc
@only_in_nb size = [rand() * rand() * 5000 for i ∈ 1:length(x)]

# ╔═╡ 545a44dc-3a67-4cdf-92f4-fbc33342e2ef
@only_in_nb D3Canvas([Shape(x, y, size;
    cwidth=300,
	cheight=300,
	offset=50,
	d3Attributes=D3Attributes(;attributes=Dict("fill" => "blue")),
	shapeType=Triangle),
	Shape(x, y, size .* 0.5;
    cwidth=300,
	cheight=300,
	offset=50,
	d3Attributes=D3Attributes(;attributes=Dict("fill" => "red"))),
	Shape(x, y, size .* 0.25;
    cwidth=300,
	cheight=300,
	offset=50,
	d3Attributes=D3Attributes(;attributes=Dict("fill" => "green")),
	shapeType=Square)
], "circle_example";
	d3Attributes=D3Attributes(;
		attributes=Dict(
			"viewBox" => "0 0 300 300"
		),
		style=Dict(
			"width" => "300",
			"height" => "300"
		)
))

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

julia_version = "1.7.1"
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
# ╠═56c9d966-382d-4c31-95ae-3af31be8e319
# ╠═e1ba78ff-a168-4a07-8b08-0299f83bc70f
# ╠═48c1bb3e-7a28-4784-bc2a-64b19bd58b49
# ╠═a084c49d-b1de-4033-93be-6d747cc66696
# ╟─f956d529-3001-4488-9898-db01aa6add73
# ╟─5ae0cf49-aa13-4681-b9d1-0383cd39d8f1
# ╠═e00085a9-8fc3-4205-8037-b9ddb7090862
# ╠═59af5f8a-8383-4d3e-bc9b-39a99769515e
# ╟─5e895427-8660-44b2-8639-f0f3d701265d
# ╠═3dbad6fc-e54e-49ee-a5f2-31ace0581812
# ╟─3caffb89-d565-43b0-85ae-3a431d378f67
# ╠═3d5b3b66-70d6-4ee7-b87d-e95f5fbe884a
# ╠═e3c572e1-f4df-4b55-8ada-2221cffca8a7
# ╠═231107ce-cdc2-413f-91d0-5df25124d9b6
# ╠═75adb70c-1cb0-4dd3-8ee4-a054e32094c9
# ╠═55930668-9a5d-4352-bfac-1332355f3afc
# ╠═545a44dc-3a67-4cdf-92f4-fbc33342e2ef
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002