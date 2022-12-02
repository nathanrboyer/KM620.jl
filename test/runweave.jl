#@testitem "show equations" begin

    using DataFrames, Latexify, LaTeXStrings, Weave, Test
    set_chunk_defaults!(:echo => false)
    weave(normpath(@__DIR__, "..", "src/KM620_.jl"); doctype = "md2pdf", out_path = normpath(@__DIR__, "..", "KM620.pdf"))
    @test isfile(normpath(@__DIR__, "..", "KM620.pdf"))

#end