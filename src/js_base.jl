### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ 2658c9f2-af72-11ec-1bd4-6d9866631eca
using HypertextLiteral

# ╔═╡ 3039100d-1a94-422a-b362-8a7ebc886b33
d3_import = read(joinpath(@__DIR__, "js/d3-import.js"), String)

# ╔═╡ 72856f1a-9784-4463-802e-24e201b2dc3c
function import_local_js(code::AbstractString)

	code_js = 
		try
		Main.PlutoRunner.publish_to_js(code)
	catch
		repr(code)
	end
	
	HypertextLiteral.JavaScript(
		"""
		await (() => {
		
		window.created_imports = window.created_imports ?? new Map()
		
		let code = $(code_js)

		if(created_imports.has(code)){
			return created_imports.get(code)
		} else {
			let blob_promise = new Promise((r) => {
        		const reader = new FileReader()
        		reader.onload = async () => r(await import(reader.result))
        		reader.readAsDataURL(
				new Blob([code], {type : "text/javascript"}))
    		})
			created_imports.set(code, blob_promise)
			return blob_promise
		}
		})()
		"""
	)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"
"""

# ╔═╡ Cell order:
# ╠═2658c9f2-af72-11ec-1bd4-6d9866631eca
# ╠═3039100d-1a94-422a-b362-8a7ebc886b33
# ╠═72856f1a-9784-4463-802e-24e201b2dc3c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
