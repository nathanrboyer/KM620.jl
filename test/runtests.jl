using Pkg
Pkg.activate(normpath(joinpath(@__FILE__, "..")))
using Pluto
Pluto.run(notebook=normpath(joinpath(@__FILE__, "..", "..", "src","KM620_notebook.jl")))
