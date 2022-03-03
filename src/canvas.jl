### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 36a5f97a-7d42-4c54-953f-70c520244d53
using AbstractPlutoDingetjes, HypertextLiteral

# ╔═╡ 30a1ef4a-4f4c-4165-8e36-22b5a390ccbc
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ 0febb961-edef-469b-b6e5-238f3cef7736
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ 560bd2ad-9ad4-4961-b202-de531cc70e08
@skip_as_script begin
	using Pkg
	using Revise
	Pkg.activate(Base.current_project(@__DIR__))
	using PlutoD3, PlutoUI
end

# ╔═╡ 7b5b0fb8-4a1a-436d-8e39-89a609f22f4d
@skip_as_script PlutoUI.TableOfContents()

# ╔═╡ 9f9b6c9e-02ec-4095-879d-6ac4abc44cb8
md"# Ingredients"

# ╔═╡ fd577d77-9aa4-4ccd-b9ad-ac91bd4937f3
md"# Canvas"

# ╔═╡ a34c9b8f-8c57-45e6-a548-715442884ac7
md"## Structure"

# ╔═╡ 591ebc46-06c0-4ffc-85fc-30a35975bed1
begin
	struct D3Canvas
		components   :: Vector{Any} # TODO: Set this to <:D3.D3Component 
		d3Attributes :: D3Attributes
		id           :: String
		initWidth    :: Int64
		initHeight   :: Int64
	end

	# Make id as PlutoRunner.currently_running_cell_id
	function D3Canvas(components::Vector{}, id::String; d3Attributes=D3.D3Attributes(), initWidth=100, initHeight=100)
		D3Canvas(components, d3Attributes, id, initWidth, initHeight)
	end
end;

# ╔═╡ ce31255b-fd64-4b01-86b5-f39f689c9766
md"## Javascript Snippet"

# ╔═╡ 61c3a0c2-5a4e-4114-a57f-099cfe05f7fd
Base.show(io::IO, m::MIME"text/html", canvas::D3Canvas) =
	Base.show(io, m, @htl("""
<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>
<script id="canvas-$(canvas.id)">
	const svg = this == null ? DOM.svg($(canvas.initWidth),$(canvas.initHeight)) : this;
	const s = this == null ? d3.select(svg) : this.s;

	var comp_foos = $(canvas.components);

	for (var i = 0; i < comp_foos.length; i++) {
		comp_foos[i](i);
	}

    s.transition()
     .duration($(canvas.d3Attributes.animationTime))
     $(canvas.d3Attributes)

	const output = svg
	output.s = s
	return output
</script>
"""))

# ╔═╡ Cell order:
# ╠═36a5f97a-7d42-4c54-953f-70c520244d53
# ╟─30a1ef4a-4f4c-4165-8e36-22b5a390ccbc
# ╟─0febb961-edef-469b-b6e5-238f3cef7736
# ╠═7b5b0fb8-4a1a-436d-8e39-89a609f22f4d
# ╟─9f9b6c9e-02ec-4095-879d-6ac4abc44cb8
# ╠═560bd2ad-9ad4-4961-b202-de531cc70e08
# ╟─fd577d77-9aa4-4ccd-b9ad-ac91bd4937f3
# ╟─a34c9b8f-8c57-45e6-a548-715442884ac7
# ╠═591ebc46-06c0-4ffc-85fc-30a35975bed1
# ╟─ce31255b-fd64-4b01-86b5-f39f689c9766
# ╠═61c3a0c2-5a4e-4114-a57f-099cfe05f7fd
