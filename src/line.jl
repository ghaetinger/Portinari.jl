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

# ╔═╡ 8bbbffda-f8ed-4d4a-b56b-dd0e1327e4da
using AbstractPlutoDingetjes, HypertextLiteral, Parameters, PlutoUI, PlutoDevMacros, Deno_jll

# ╔═╡ 96869bca-d552-4212-bb4b-969e68d0a990
PlutoUI.TableOfContents()

# ╔═╡ 02c62a40-253e-49ef-8ea9-beb2cffe4196
md"# Ingredients"

# ╔═╡ 59597ab2-369e-4a9f-921a-d63649d1bba4
@plutoinclude "./context.jl" "all"

# ╔═╡ b30f2165-0980-42c9-a3cf-e36033083a2a
md"# Line"

# ╔═╡ cf44495e-6bb9-456b-bcd5-a06b7b6e2d0e
md"## Structure"

# ╔═╡ 5984fc30-37d1-4e6d-beab-2233c928173d
begin
  struct Line <: D3Component
    data       :: Vector{NamedTuple{(:x, :y), Tuple{<:Real, <:Real}}}
	attributes :: D3Attr
	curveType  :: Curve
	id         :: String
  end

Line(x, y, id;
        attributes=D3Attr(), curveType=Linear
  ) = Line(
	  [(x=x[i], y=y[i]) for i ∈ 1:length(x)],
	  attributes,
	  curveType,
	  id
  )
end;

# ╔═╡ e2ef20fd-ba3d-4c4b-9d1d-ea8f64a3b48d
function Base.extrema(line::Line)
	xs = (v -> v.x).(line.data)
	ys = (v -> v.y).(line.data)
	return (minx=minimum(xs), miny=minimum(ys), maxx=maximum(xs), maxy=maximum(ys))
end

# ╔═╡ abec8fbc-e87e-484a-8386-f133d28eacab
md"## Javascript Snippet"

# ╔═╡ 92161843-357d-47ac-8da3-27b134b22084
Base.show(io::IO, m::MIME"text/javascript", line::Line) =
    show(io, m, @js """
	line(
		$(PublishToJS(line.data)),
		ctx,
		x_scale,
		y_scale,
		$(PublishToJS(to_named_tuple(line.attributes))),
		$(line.id),
		d3.$(line.curveType)
	);
	""")

# ╔═╡ d68ffecb-be5c-487c-8e22-7851312e9aa7
Base.show(io::IO, m::MIME"text/html", line::Line) =	show(io, m, @htl("""
	<span id=$(line.id)>
	<script id="preview-$(line.id)">
	const { d3, line_standalone } = $(import_local_js(bundle_code));
	const svg = this == null ? DOM.svg(600, 300) : this;
	const s = this == null ? d3.select(svg) : this.s;

	line_standalone(
		$(PublishToJS(line.data)),
		s,
		$(PublishToJS(to_named_tuple(line.attributes))),
		$(line.id),
		d3.$(line.curveType)
	);

	const output = svg
	output.s = s
	return output
	</script>
	</span>
"""))

# ╔═╡ ba53d4cc-b096-4fb8-86f3-ee8648c10cea
md"# Example"

# ╔═╡ 93677f4d-c031-4432-8705-56575e20515b
@only_in_nb sz_ui = @bind sz Slider(0:30)

# ╔═╡ 19a6176a-9a60-4e6c-86e0-38303bb78813
@only_in_nb x = collect(0:sz+1);

# ╔═╡ 99fdeb31-01b8-4be5-bb42-fcc4f2da91ef
@only_in_nb y = vcat([1], [rand() for _ ∈ (1:sz+1)]);

# ╔═╡ 0a27990c-f78e-4e10-875c-bbb07a2712a6
@only_in_nb @bind lineev line = Line(x, y, "line_id";
	attributes=D3Attr(;
		attr=(;
			fill="none",
			stroke="green",
			var"stroke-width"="3.0"
		),
		events=["click", "mouseover", "mousemove"],
		duration=200
	),
	curveType=Linear
)

# ╔═╡ 94478d85-7d0e-44e0-bf13-a8a84a2ad83d
@only_in_nb ismissing(lineev) ? md"" : @htl("""
	$([@htl("""<h4>$ev : $(descr["count"])</h4>""") for (ev, descr) ∈ lineev])
""")

# ╔═╡ 702c3e6a-938f-4619-87d6-9c0313402158
@only_in_nb ctx = Context(
	(;domain=[extrema(x)...], range=[0, 690]),
	(;domain=[extrema(y)...], range=[0, 300]),
	[line],
	"ctx"
);

# ╔═╡ 1cd9f10e-e995-451a-91d2-b97520ee96e3
@only_in_nb begin
	rows = 16
	cols = 16
	ctxs = []
	rows_val = 1 / rows
	cols_val = 1 / cols

	row = Context(
		(domain=[0, 0], range=[0, 690]),
		(domain=[0, 0], range=[0, 300]),
		[Scale(Restyle(ctx, 
			D3Attr(;
				style=(;
					transform= i % 2 == 0 ? "scale(1, 1)" : "scale(-1, 1)",
					stroke="rgb($(rand() * 255), $(rand() * 255), $(rand() * 255))"
				)),
			"restyle-$i"
		), (i * cols_val, (i+1) * cols_val), (0.0, 1.0), "scale-$i") for i ∈ (0:cols-1)] |> vec,
		"row"
	);

	Context(
		(domain=[0, 0], range=[0, 690]),
		(domain=[0, 0], range=[0, 600]),
		[Scale(Restyle(row, 
			D3Attr(;style=(;transform= i % 2 == 0 ? "scale(1, 1)" : "scale(1, -1)")),
			"restyle-row-$i"
		), (0.0, 1.0), (i * rows_val, (i+1) * rows_val), "scale-row-$i")
			for i ∈ (0:rows-1)] |> vec,
		"all";
		drawAxis=false
	)
end

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
# ╟─96869bca-d552-4212-bb4b-969e68d0a990
# ╟─02c62a40-253e-49ef-8ea9-beb2cffe4196
# ╠═8bbbffda-f8ed-4d4a-b56b-dd0e1327e4da
# ╠═59597ab2-369e-4a9f-921a-d63649d1bba4
# ╟─b30f2165-0980-42c9-a3cf-e36033083a2a
# ╟─cf44495e-6bb9-456b-bcd5-a06b7b6e2d0e
# ╠═5984fc30-37d1-4e6d-beab-2233c928173d
# ╠═e2ef20fd-ba3d-4c4b-9d1d-ea8f64a3b48d
# ╟─abec8fbc-e87e-484a-8386-f133d28eacab
# ╠═92161843-357d-47ac-8da3-27b134b22084
# ╠═d68ffecb-be5c-487c-8e22-7851312e9aa7
# ╟─ba53d4cc-b096-4fb8-86f3-ee8648c10cea
# ╠═19a6176a-9a60-4e6c-86e0-38303bb78813
# ╠═99fdeb31-01b8-4be5-bb42-fcc4f2da91ef
# ╟─94478d85-7d0e-44e0-bf13-a8a84a2ad83d
# ╠═0a27990c-f78e-4e10-875c-bbb07a2712a6
# ╠═702c3e6a-938f-4619-87d6-9c0313402158
# ╟─1cd9f10e-e995-451a-91d2-b97520ee96e3
# ╟─93677f4d-c031-4432-8705-56575e20515b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
