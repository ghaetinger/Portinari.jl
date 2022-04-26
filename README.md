# Portinari.jl

A Julian abstraction for D3 to be run inside of Pluto! Still in its early stages.

## Small demo

https://user-images.githubusercontent.com/23220288/161279567-6ab6a7b8-3ee0-404b-b003-8da99022045a.mp4

# Features

- Lines
- Areas
- Shapes (scatter)
- Pluto hooked events

# Notebook Hierarchy

```mermaid
graph TD;
    js_base.jl-->d3_abstractions.jl
    d3_abstractions.jl-->context.jl;

    context.js-->context.jl
    d3-import.js-->context.js
    attribute_splicing.js-->context.js

    context.jl-->area.jl;
    area.js-->area.jl
    d3-import.js-->area.js
    attribute_splicing.js-->area.js

    context.jl-->line.jl;
    line.js-->line.jl
    d3-import.js-->line.js
    attribute_splicing.js-->line.js

    context.jl-->shape.jl;
    shape.js-->shape.jl
    d3-import.js-->shape.js
    attribute_splicing.js-->shape.js

    d3-import.js-->index.js
    attribute_splicing.js-->index.js

    index.js-->js_base.jl 
```
