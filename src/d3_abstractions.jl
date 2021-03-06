### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ 774bb4f2-963e-11ec-30ff-e3394f52858b
using HypertextLiteral, Parameters, PlutoDevMacros, Deno_jll

# ╔═╡ d12da0cd-80fe-4c09-907b-d20a81c07c1c
@only_in_nb using PlutoUI

# ╔═╡ 320477a5-77ad-40b3-bccd-37a06c06c22e
@only_in_nb TableOfContents()

# ╔═╡ b1d3d2ca-aa67-47de-a2a8-6119f3ca4e46
md"# Ingredients"

# ╔═╡ bad43269-199b-4176-8548-8a963268cb46
@plutoinclude "./js_base.jl" "all"

# ╔═╡ 09e4ee53-b8b7-4de0-9439-d1bc7bc22578
md"# Javascript Snippet macro"

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
			"((ctx, x_scale, y_scale) => {" * full_result[1+length("<script>"):end-length("</script>")] * "})"
		)
	end
end

# ╔═╡ 227f7480-a39d-4692-9874-ff9328e4080a
begin
macro js(str_expr::Expr)
	QuoteNode(str_expr)
	quote
		result = @htl( $(Expr(:string, "<script>", esc_if_needed.(str_expr.args)..., "</script>")) )
		RenderWithoutScriptTags(result)
	end
end
macro js(str_expr::String)
	QuoteNode(str_expr)

	quote
		result = @htl( $(Expr(:string, "<script>", esc_if_needed(str_expr), "</script>")) )
		RenderWithoutScriptTags(result)
	end
end
end

# ╔═╡ e3156da9-8603-41f9-ad41-03eaf79c4540
md"# D3"

# ╔═╡ b5110c15-0b46-4450-b8d2-9a83f7aeef54
md"## D3 Component Type"

# ╔═╡ c06a51f5-224a-4ffa-87a7-d5f39a1a4bb5
abstract type D3Component end

# ╔═╡ 37f3557c-0d82-464d-9f36-847eceebaae6
Base.extrema(component::D3Component) =
	error("Extrema not implemented for type $(typeof(component))")

# ╔═╡ d8c59da2-5a98-4321-89f2-4766d9ad14c6
md"## D3 Attributes"

# ╔═╡ c80d5063-aac3-4ee7-994c-eb6394b225eb
@with_kw struct D3Attr
  attr     :: NamedTuple = (;)
  style    :: NamedTuple = (;)
  duration :: Int = 200
  events   :: Vector{<:AbstractString} = String[]
end

# ╔═╡ 813d7b17-a806-4d9e-95ed-e095a43a8291
to_named_tuple(attr::D3Attr) = (attr=attr.attr, style=attr.style, duration=attr.duration, events=attr.events)

# ╔═╡ 1eaa1bb9-7893-4181-973c-feda25677ef3
md"## Curve Types"

# ╔═╡ 25710a40-fe6a-4f1d-8851-00ddc810d8f4
@enum Curve Cardinal Natural CatmullRom MonotoneX MonotoneY Basis BasisClosed Linear LinearClosed

# ╔═╡ 5e2b8127-3385-406a-8de1-4acb74ff3126
md"## Shape Types"

# ╔═╡ e19d9ac1-b314-4901-a448-f58230011b05
@enum ShapeType Square Circle Triangle

# ╔═╡ 9763e4b9-515d-4576-9f76-1b337365d6a6
Base.show(io::IO,  m::MIME"text/javascript", shapeType::ShapeType) = Base.show(io, m, HypertextLiteral.JavaScript("d3.symbol" * (string(shapeType))))

# ╔═╡ 743f182a-46da-4732-b1e4-5a237912848f
Base.show(io::IO,  m::MIME"text/javascript", curve::Curve) = Base.show(io, m, HypertextLiteral.JavaScript("curve" * string(curve)))

# ╔═╡ 8803b1d9-a29c-4b4c-b5bc-93a78561a70f
begin
	struct PublishToJS
	x
	end
	function Base.show(io::IO, m::MIME"text/javascript", ptj::PublishToJS)
		Base.show(io, m, Main.PlutoRunner.publish_to_js(ptj.x))
	end
	better_publish_to_js(x) = PublishToJS(x)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Deno_jll = "04572ae6-984a-583e-9378-9577a1c2574d"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Deno_jll = "~1.20.4"
HypertextLiteral = "~0.9.3"
Parameters = "~0.12.3"
PlutoDevMacros = "~0.4.5"
PlutoUI = "~0.7.38"
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

[[deps.Deno_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "970da1e64a94f13b51c81691c376a1d5a83a0b3c"
uuid = "04572ae6-984a-583e-9378-9577a1c2574d"
version = "1.20.4+0"

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

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

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
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

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
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "d3538e7f8a790dc8903519090857ef8e1283eecd"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.5"

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
# ╠═774bb4f2-963e-11ec-30ff-e3394f52858b
# ╟─d12da0cd-80fe-4c09-907b-d20a81c07c1c
# ╟─320477a5-77ad-40b3-bccd-37a06c06c22e
# ╟─b1d3d2ca-aa67-47de-a2a8-6119f3ca4e46
# ╠═bad43269-199b-4176-8548-8a963268cb46
# ╟─09e4ee53-b8b7-4de0-9439-d1bc7bc22578
# ╠═4d193bff-9ed2-42ba-9cef-4d8c9abc8332
# ╠═c9458743-0471-430e-b7a5-e26a2ccb5811
# ╠═279012f1-b67a-4fac-a169-34dbe47e4638
# ╠═227f7480-a39d-4692-9874-ff9328e4080a
# ╠═8803b1d9-a29c-4b4c-b5bc-93a78561a70f
# ╟─e3156da9-8603-41f9-ad41-03eaf79c4540
# ╟─b5110c15-0b46-4450-b8d2-9a83f7aeef54
# ╠═c06a51f5-224a-4ffa-87a7-d5f39a1a4bb5
# ╠═37f3557c-0d82-464d-9f36-847eceebaae6
# ╟─d8c59da2-5a98-4321-89f2-4766d9ad14c6
# ╠═c80d5063-aac3-4ee7-994c-eb6394b225eb
# ╠═813d7b17-a806-4d9e-95ed-e095a43a8291
# ╟─1eaa1bb9-7893-4181-973c-feda25677ef3
# ╠═25710a40-fe6a-4f1d-8851-00ddc810d8f4
# ╠═743f182a-46da-4732-b1e4-5a237912848f
# ╟─5e2b8127-3385-406a-8de1-4acb74ff3126
# ╠═e19d9ac1-b314-4901-a448-f58230011b05
# ╠═9763e4b9-515d-4576-9f76-1b337365d6a6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
