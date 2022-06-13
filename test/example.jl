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

# ╔═╡ 82e0613e-b50e-11ec-0a7e-050ecf0c92ca
begin
	using Pkg
	using Revise
	Pkg.activate(dirname(Base.current_project(@__DIR__)))
	using PlutoUI, Portinari
end

# ╔═╡ dba679be-b646-48b2-ad36-e257fcc100f4
@bind sz Slider(1:100; show_value=true)

# ╔═╡ 6c52e239-e5bd-47c2-af70-19be6545acb3
x = collect(1:sz)

# ╔═╡ 4d754375-9fa1-43f6-880b-25c1b57e4ddf
y = rand(sz)

# ╔═╡ 78c862a6-a979-430b-8d46-1e1a94a394a9
line = Line(x, y, "base-line";
	attributes=D3Attr(style=(;fill="none", stroke="green", var"stroke-width"="3"))
)

# ╔═╡ 83870a8f-0f9b-4b0f-8d28-a8e1820e3b87
val = rand(sz) .* 500

# ╔═╡ 61ae25d3-e6c1-471b-b029-303f29c88970
shapes = Shape(x, y, val, "base-shapes";
	attributes=D3Attr(style=(;fill="rgba(255, 0, 0, 0.3)"))
)

# ╔═╡ 1149fcb4-909c-4250-bb69-39dff8a44c47
together = Context(
	(;domain=([extrema(x)...]), range=[0, 630]),
	(;domain=([extrema(y)...]), range=[0, 300]),
	[line, shapes],
	"together"
)

# ╔═╡ fa9c38b1-dbed-4fbd-a0a0-6ca80d38c855
together_rev = Context(
	(;domain=([extrema(x)...]), range=[0, 630]),
	(;domain=(reverse([extrema(y)...])), range=[0, 300]),
	[line, shapes],
	"together"
)

# ╔═╡ 6de965b1-62d8-491e-b632-386d8f7a0fca
merge = Context(
	(;domain=[0, 0], range=[50, 600]),
	(;domain=[0, 0], range=[50, 300]),
	[
		Scale(together, (0.0, 1.0), (0.0, 0.5), "together-scale"),
		Scale(together_rev, (0.0, 1.0), (0.5, 0.8), "together-rev-scale"),
	],
	"merge"
)

# ╔═╡ 6516c1ba-bbf3-466f-8619-4fa61838a5b0
Context(
	(;domain=([extrema(x)...]), range=[0, 630]),
	(;domain=([extrema(y)...]), range=[0, 300]),
	[
		line,
		Axis(Portinari.Right, "testaxis"; attributes=D3Attr(;
			style=(;transform="translateX(315px)")
		)),
		Axis(Portinari.Bottom, "testaxisy"; attributes=D3Attr(;
			style=(;transform="translateY(150px)")
		))
	],
	"test";
	drawAxis=false
)

# ╔═╡ Cell order:
# ╠═82e0613e-b50e-11ec-0a7e-050ecf0c92ca
# ╟─6c52e239-e5bd-47c2-af70-19be6545acb3
# ╟─4d754375-9fa1-43f6-880b-25c1b57e4ddf
# ╠═83870a8f-0f9b-4b0f-8d28-a8e1820e3b87
# ╠═78c862a6-a979-430b-8d46-1e1a94a394a9
# ╠═61ae25d3-e6c1-471b-b029-303f29c88970
# ╠═1149fcb4-909c-4250-bb69-39dff8a44c47
# ╠═fa9c38b1-dbed-4fbd-a0a0-6ca80d38c855
# ╠═6de965b1-62d8-491e-b632-386d8f7a0fca
# ╟─dba679be-b646-48b2-ad36-e257fcc100f4
# ╠═6516c1ba-bbf3-466f-8619-4fa61838a5b0
