### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ 0cde3f18-6b7e-4c96-a09e-b5419d481053
using AbstractPlutoDingetjes, HypertextLiteral, Parameters, PlutoUI, PlutoDevMacros, PlutoLinks, Deno_jll

# ╔═╡ 5ee4e18c-8a03-41c8-ab2c-2c3ff430f5f8
@only_in_nb PlutoUI.TableOfContents()

# ╔═╡ 652695a3-5c8b-4cea-b79c-fe1192df8527
md"# Ingredients"

# ╔═╡ 01e347d4-a998-476a-a549-bbd591330439
@plutoinclude "./d3_abstractions.jl" "all"

# ╔═╡ 0a077719-b3a6-4393-818e-736c624d3caa
md"# Axis"

# ╔═╡ 9d8a1b6d-d2ae-4654-a341-663262a5c97f
md"## Positions"

# ╔═╡ 54dd4348-f96e-4621-93a9-6d29585e300c
md"### Orientation"

# ╔═╡ d4d8079a-8e80-4f8c-a741-c7882cf95c0f
@enum Orientation Horizontal Vertical

# ╔═╡ 15dfc897-41ba-453e-a2f8-8aaf8b26985d
md"### Horizontal"

# ╔═╡ 8b0b7d98-1fcf-4539-b7bd-91f683600ed2
@enum HDir Top Bottom

# ╔═╡ dfeade78-3b1d-4b58-8501-71a6a3c39ec3
Base.show(io::IO, m::MIME"text/javascript", pos::HDir) =
	show(io, m, HypertextLiteral.JavaScript("axis"  * string(pos)))

# ╔═╡ 1d6ef644-15a1-46b2-b3e2-75ce68424fdd
md"### Vertical"

# ╔═╡ 76a72022-fdf6-4715-a793-241ddd452f12
@enum VDir Left Right

# ╔═╡ 29a2095f-9fca-4599-b6e2-4f14467544cb
Base.show(io::IO, m::MIME"text/javascript", pos::VDir) =
	show(io, m, HypertextLiteral.JavaScript("axis"  * string(pos)))

# ╔═╡ 6b95627d-0d5a-455a-b9d8-f29bf23c4e9d
md"## Structure"

# ╔═╡ b0e3453f-45c0-465b-9df5-476a7d6ff42f
# begin
# 	struct Axis{Orientation} <: D3Component where T
#   		domain       :: Tuple{<:Number, <:Number}
# 		range        :: Tuple{<:Number, <:Number}
# 		show         :: Bool
# 		direction    :: Union{HDir, VDir}
# 		d3Attributes :: D3Attr
#  	 end

#   	function Axis(
# 	  			values::Vector{<:Number}, range, dir::Union{HDir, VDir};
# 				attributes=D3Attr(),
#   				show=false, orientation=Horizontal
#   	)
# 		domain = Base.extrema(values)
# 		Axis{orientation}(domain, range |> Tuple, show, dir, attributes)
#   	end

# 	function Axis(values::Vector{<:Number}, size::Number, dir::Union{HDir, VDir};
# 	offset::Vector{<:Number}=(0.0, 0.0), attributes=D3Attr(), show=false, orientation=Horizontal)
# 		Axis(values, [offset[1], size-offset[2]], dir; attributes=attributes, show=show, orientation=orientation)
# 	end

# 	HAxis(arguments...; extra...) =
# 		Axis(arguments...; merge((;extra...), (;orientation=Horizontal))...)
	
# 	VAxis(arguments...; extra...) =
# 		Axis(arguments...; merge((;extra...), (;orientation=Vertical))...)
# end

# ╔═╡ 0b4accf0-16a1-4985-9723-f8f1a879506c
md"## Javascript Snippet"

# ╔═╡ c60565ba-7ec1-482f-8086-4d800acd9520
# begin
# function Base.show(io::IO, m::MIME"text/javascript", axis::Axis{Horizontal}) 
# show(io, m, @js("""
# 	var size = xRange[1] - xRange[0];
# 	xRange = [$(axis.range[1]) * size + xRange[0], $(axis.range[2]) * size + xRange[0]];   
# 	const scale = d3.scaleLinear()
#       .domain($([axis.domain...]))
#       .range(xRange);

# 	var axis_descr = d3.$(axis.direction)()
#     	               .scale(scale);

# 	const axis = s.selectAll(".axis-" + id)
#        	          .data([1])
#          		  .join("g")
# 		 		  .attr("class", "axis-" + id)
#          		  .call(axis_descr);

# 	if ($(!axis.show)) {
# 		axis.style("visibility", "hidden");
# 	}


#     return [scale, axis]
# """))
# end

# function Base.show(io::IO, m::MIME"text/javascript", axis::Axis{Vertical})
# show(io, m, @js("""
# 	var size = yRange[1] - yRange[0];
# 	yRange = [$(axis.range[1]) * size + yRange[0], $(axis.range[2]) * size + yRange[0]];
# 	const scale = d3.scaleLinear()
#       .domain($([axis.domain...]))
#       .range(yRange);

# 	var axis_descr = d3.$(axis.direction)()
#     	               .scale(scale);

# 	const axis = s.selectAll(".axis-" + id)
#        	          .data([1])
#          		  .join("g")
# 		 		  .attr("class", "axis-" + id)
#          		  .call(axis_descr);

# 	if ($(!axis.show)) {
# 		axis.style("visibility", "hidden");
# 	}

#     return [scale, axis]
# """))
# end
# end

# ╔═╡ 9df4facb-6862-4898-aa04-ae944c94969f
md"# Context"

# ╔═╡ 6fdebb9a-3053-4699-bd3b-6fa4c43c3283
md"## Structure"

# ╔═╡ b1efe9b3-45fc-48b2-b754-ade9938647d3
# begin	
# 	# Axis not defined??
# 	struct Context <: D3Component
# 		hAxis         
# 		vAxis         
# 		children     #:: Vector{<:D3Component}
# 		d3Attributes :: D3Attr
# 		mods         :: Vector{Function}
# 		id           :: String
# 		width        
# 		height       
#   	end

# 	function Context(
# 		children::Vector{<:D3Component}, id::String;
# 		hAxis=missing, vAxis=missing,
# 		attributes=D3Attr(),
# 		mods=[],
# 		width=300.0,
# 		height=300.0,
# 		offset=[0.0, 0.0]
# 	)
# 		child_bounds = Base.extrema(children)
# 		hAxis = ismissing(hAxis) ? Axis(
# 			[child_bounds.minx, child_bounds.maxx], 0.8, Bottom; offset=offset
# 		) : hAxis
# 		vAxis = ismissing(vAxis) ? Axis(
# 			[child_bounds.miny, child_bounds.maxy], 0.8, Right; orientation=Vertical, offset=offset
# 		) : vAxis
# 		Context(hAxis, vAxis, children, attributes, mods, id, width, height)
# 	end
		
# 	function Base.extrema(ctx::Context)
# 		Base.extrema(ctx.children)
# 	end
# end

# ╔═╡ 82090d2a-bc09-4f5e-8377-3452fdaeca46
begin
	Axis = @NamedTuple{domain::Vector{<:Number}, range::Vector{<:Number}}
	struct Context <: D3Component
		xAxis 	   :: Axis
		yAxis 	   :: Axis
		children   :: Vector{<:D3Component}
		attributes :: D3Attr
		id         :: String
	end
end

# ╔═╡ 2bc3ddd7-1a16-4dcc-a029-555697987f17
begin
function Base.extrema(children::Vector{<:D3Component})
	extremas = (Base.extrema).(children)
	minxs = (v -> v.minx).(extremas)
	minys = (v -> v.miny).(extremas)
	maxxs = (v -> v.maxx).(extremas)
	maxys = (v -> v.maxy).(extremas)

	return (
		minx=minimum(minxs),
		miny=minimum(minys),
		maxx=maximum(maxxs),
		maxy=maximum(maxys)
	)
end
end

# ╔═╡ 28c2fbc1-fa21-4ace-86c8-d085f19af466
md"## Javascript Snippet"

# ╔═╡ baa7bf03-77f8-4fa1-9635-df02629cfe01
function Base.show(io::IO, m::MIME"text/javascript", ctx::Context) 
show(io, m, @js("""
	context_standalone(
		ctx,
		$(PublishToJS(ctx.xAxis.domain)),
		$(PublishToJS(ctx.xAxis.range)),
		$(PublishToJS(ctx.yAxis.domain)),
		$(PublishToJS(ctx.yAxis.range)),
		$(PublishToJS(to_named_tuple(ctx.attributes))),
		$(ctx.children),
		$(ctx.id)
	)
"""))
end

# ╔═╡ 2b0b5165-776a-4d1f-9151-19465d75124c
Base.show(io::IO, m::MIME"text/html", ctx::Context) =
	show(io, m, @htl("""
	<span id=$(ctx.id)>
	<script id="context-$(ctx.id)">

	const { 
		d3,
  		context,
  		context_standalone,
  		area, line, shape,
  		area_standalone, line_standalone, shape_standalone
	} = $(import_local_js(bundle_code));
	
	const svg = this == null ? DOM.svg($(maximum(ctx.xAxis.range)), $(maximum(ctx.yAxis.range))) : this;
	const s = this == null ? d3.select(svg) : this.s;

	context_standalone(
	s,	
	$(PublishToJS(ctx.xAxis.domain)),
	$(PublishToJS(ctx.xAxis.range)),
	$(PublishToJS(ctx.yAxis.domain)),
	$(PublishToJS(ctx.yAxis.range)),
	$(PublishToJS(to_named_tuple(ctx.attributes))),
	$(ctx.children),
	$(ctx.id)
	)

	const output = svg
	output.s = s
	return output
	</script>
	</span>
"""))

# ╔═╡ a46f89d7-3670-4860-9bf3-eafffa5c5f48
md"# Modifier functions"

# ╔═╡ 6b0ce571-1f96-40a7-839c-c0ae2efb3107
# ╠═╡ disabled = true
#=╠═╡
function zoom(ctx::Context)
	@js("""
		var zoom = d3.zoom()
		.on("zoom", updateChart);

		s.call(zoom);

		function updateChart(event, data) {
			const constXScale = xScale;
			const constYScale = yScale;
	
			xScale = event.transform.rescaleX(xScale);
    		yScale = event.transform.rescaleY(yScale);

    		xAxis.call(d3.$(ctx.hAxis.direction)(xScale))
    		yAxis.call(d3.$(ctx.vAxis.direction)(yScale))

			for (var i = 0; i < comp_foos.length; i++) {
				comp_foos[i](s, $(ctx.id) + (i + 2), _span, true, event.transform);
			}
	
			xScale = constXScale;
			yScale = constYScale;
		}
	""")
end
  ╠═╡ =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
Deno_jll = "04572ae6-984a-583e-9378-9577a1c2574d"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Parameters = "d96e819e-fc66-5662-9728-84c9c7592b0a"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoLinks = "0ff47ea0-7a50-410d-8455-4348d5de0420"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractPlutoDingetjes = "~1.1.4"
Deno_jll = "~1.20.4"
HypertextLiteral = "~0.9.3"
Parameters = "~0.12.3"
PlutoDevMacros = "~0.4.5"
PlutoLinks = "~0.1.5"
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

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "9fb640864691a0936f94f89150711c36072b0e8f"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.0.8"

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

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
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

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "9c43a2eb47147a8776ca2ba489f15a9f6f2906f8"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.11"

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

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "6b0440822974cab904c8b14d79743565140567f6"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.2.1"

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

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "0e8bcc235ec8367a8e9648d48325ff00e4b0a545"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.5"

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

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "4d4239e93531ac3e7ca7e339f15978d0b5149d03"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.3.3"

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
# ╟─5ee4e18c-8a03-41c8-ab2c-2c3ff430f5f8
# ╟─652695a3-5c8b-4cea-b79c-fe1192df8527
# ╠═0cde3f18-6b7e-4c96-a09e-b5419d481053
# ╠═01e347d4-a998-476a-a549-bbd591330439
# ╟─0a077719-b3a6-4393-818e-736c624d3caa
# ╟─9d8a1b6d-d2ae-4654-a341-663262a5c97f
# ╟─54dd4348-f96e-4621-93a9-6d29585e300c
# ╠═d4d8079a-8e80-4f8c-a741-c7882cf95c0f
# ╟─15dfc897-41ba-453e-a2f8-8aaf8b26985d
# ╠═8b0b7d98-1fcf-4539-b7bd-91f683600ed2
# ╠═dfeade78-3b1d-4b58-8501-71a6a3c39ec3
# ╟─1d6ef644-15a1-46b2-b3e2-75ce68424fdd
# ╠═76a72022-fdf6-4715-a793-241ddd452f12
# ╠═29a2095f-9fca-4599-b6e2-4f14467544cb
# ╟─6b95627d-0d5a-455a-b9d8-f29bf23c4e9d
# ╠═b0e3453f-45c0-465b-9df5-476a7d6ff42f
# ╟─0b4accf0-16a1-4985-9723-f8f1a879506c
# ╠═c60565ba-7ec1-482f-8086-4d800acd9520
# ╟─9df4facb-6862-4898-aa04-ae944c94969f
# ╟─6fdebb9a-3053-4699-bd3b-6fa4c43c3283
# ╠═b1efe9b3-45fc-48b2-b754-ade9938647d3
# ╠═82090d2a-bc09-4f5e-8377-3452fdaeca46
# ╠═2bc3ddd7-1a16-4dcc-a029-555697987f17
# ╟─28c2fbc1-fa21-4ace-86c8-d085f19af466
# ╠═baa7bf03-77f8-4fa1-9635-df02629cfe01
# ╠═2b0b5165-776a-4d1f-9151-19465d75124c
# ╟─a46f89d7-3670-4860-9bf3-eafffa5c5f48
# ╠═6b0ce571-1f96-40a7-839c-c0ae2efb3107
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002