### A Pluto.jl notebook ###
# v0.19.5

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

# ╔═╡ 6e1e9ba6-6486-417b-97cc-127a137eb59d
using AbstractPlutoDingetjes, HypertextLiteral, Parameters, PlutoDevMacros, Deno_jll

# ╔═╡ f5754764-6985-48a0-881f-593e5a4bedd8
@only_in_nb using PlutoUI

# ╔═╡ a4821b5e-41dc-4cf1-8a35-dfebe7d0fbbf
@only_in_nb PlutoUI.TableOfContents()

# ╔═╡ c6a687a8-16ff-43ea-833e-8dd058ebedf1
md"# Ingredients"

# ╔═╡ f1d9de73-f543-458a-8407-4d7f4a3c6f80
@plutoinclude "./context.jl" "all"

# ╔═╡ 93583c73-3027-4aec-b263-34d49805c4ed
md"# Bars"

# ╔═╡ 6f6c6f25-294a-426a-a809-0e533fc17430
md"## Structure"

# ╔═╡ c9484aae-763d-4bf0-9f78-8804c4967891
const type_union = Union{String, Real}

# ╔═╡ d6c039ff-23eb-4e0b-a5e2-2d18296da421
begin
  struct Bars <: D3Component
    data       :: Vector{NamedTuple{(:x, :y), Tuple{<:type_union, <:type_union}}}
	attributes :: D3Attr
	id         :: String
  end

function Bars(x::Vector{<:type_union}, y::Vector{<:type_union}, id::String; attributes=D3Attr())
	return Bars([(x=x[i], y=y[i]) for i ∈ 1:length(x)], attributes, id)
end
end;

# ╔═╡ 1d37a584-a988-4aca-97ea-5732d24da861
function Base.extrema(bars::Bars)
	ys = (v -> v.y).(line.data)
	return (minx=0, miny=minimum(ys), maxx=length(bars.data), maxy=maximum(ys))
end

# ╔═╡ c8e12ad4-555b-4513-9c50-27f8074d1125
md"## Javascript Snippet"

# ╔═╡ c775bc28-9e65-448c-91a3-f89a572b4682
Base.show(io::IO, m::MIME"text/javascript", bars::Bars) =
    show(io, m, @js """
	line(
		$(PublishToJS(bars.data)),
		ctx,
		x_scale,
		y_scale,
		$(PublishToJS(to_named_tuple(bars.attributes))),
		$(bars.id),
	);
	""")

# ╔═╡ 75ce7f56-c772-4a94-9793-48e944632b3b
Base.show(io::IO, m::MIME"text/html", bars::Bars) =	show(io, m, @htl("""
	<span id=$(bars.id)>
	<script id="preview-$(bars.id)">
	const { d3, bar_standalone } = $(import_local_js(bundle_code));
	const svg = this == null ? DOM.svg(600, 300) : this;
	const s = this == null ? d3.select(svg) : this.s;

	bar_standalone(
		$(PublishToJS(bars.data)),
		s,
		$(PublishToJS(to_named_tuple(bars.attributes))),
		$(bars.id),
	);

	const output = svg
	output.s = s
	return output
	</script>
	</span>
"""))

# ╔═╡ 5fd37e33-6ea2-4435-8d10-66e22a5f9bdb
md"# Example"

# ╔═╡ f73e2794-216f-440f-918f-f548da0eda2f
@bind word TextField(;default="Is this working?")

# ╔═╡ 2367ee3c-a764-490a-886e-d5a0c0f63fb3
cmap = let
	lword = lowercase.(word)
	characters = lword |> unique
	collect((c=string(c), n=length(filter(_c -> _c == c, lword))) for c ∈ characters)
end;

# ╔═╡ 60ec6196-c57c-4d89-878d-b0c25ffe2766
@only_in_nb x = (p -> p.c).(cmap)

# ╔═╡ 853e58c4-0015-4c6c-aeb5-35ba4decb3fb
@only_in_nb y = (p -> p.n).(cmap)

# ╔═╡ 8387b82e-9c11-418b-a69e-d1d1d6a4000a
@bind ev Bars(x, y, "line_id"; attributes=D3Attr(;attr=(;fill="green"), duration=100, events=["mouseover"]))

# ╔═╡ 1d079b60-43b9-4b67-a187-24653032b6c0
ev

# ╔═╡ 8d23d176-e311-4d62-926a-24aac41c0ab6
Bars(y, x, "line_id";attributes=D3Attr(;attr=(;fill="red"), duration=500))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
Deno_jll = "04572ae6-984a-583e-9378-9577a1c2574d"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractPlutoDingetjes = "~1.1.4"
Deno_jll = "~1.20.4"
HypertextLiteral = "~0.9.4"
Parameters = "~0.12.3"
PlutoDevMacros = "~0.4.5"
PlutoUI = "~0.7.39"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.3"
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
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

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
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

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
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

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
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

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
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

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

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

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
# ╠═a4821b5e-41dc-4cf1-8a35-dfebe7d0fbbf
# ╟─c6a687a8-16ff-43ea-833e-8dd058ebedf1
# ╠═6e1e9ba6-6486-417b-97cc-127a137eb59d
# ╠═f1d9de73-f543-458a-8407-4d7f4a3c6f80
# ╟─93583c73-3027-4aec-b263-34d49805c4ed
# ╟─6f6c6f25-294a-426a-a809-0e533fc17430
# ╠═c9484aae-763d-4bf0-9f78-8804c4967891
# ╠═d6c039ff-23eb-4e0b-a5e2-2d18296da421
# ╠═1d37a584-a988-4aca-97ea-5732d24da861
# ╟─c8e12ad4-555b-4513-9c50-27f8074d1125
# ╠═c775bc28-9e65-448c-91a3-f89a572b4682
# ╠═75ce7f56-c772-4a94-9793-48e944632b3b
# ╟─5fd37e33-6ea2-4435-8d10-66e22a5f9bdb
# ╠═f5754764-6985-48a0-881f-593e5a4bedd8
# ╟─2367ee3c-a764-490a-886e-d5a0c0f63fb3
# ╟─f73e2794-216f-440f-918f-f548da0eda2f
# ╠═60ec6196-c57c-4d89-878d-b0c25ffe2766
# ╠═853e58c4-0015-4c6c-aeb5-35ba4decb3fb
# ╠═1d079b60-43b9-4b67-a187-24653032b6c0
# ╠═8387b82e-9c11-418b-a69e-d1d1d6a4000a
# ╠═8d23d176-e311-4d62-926a-24aac41c0ab6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
