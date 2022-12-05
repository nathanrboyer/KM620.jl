#@testitem "show equations" begin

    using DataFrames, Latexify, LaTeXStrings, Weave, Test

    set_chunk_defaults!(:echo => false)

    weave(normpath(@__DIR__, "..", "src/KM620_nomenclature.jl"); doctype = "md2pdf", out_path = normpath(@__DIR__, "..", "KM620_nomenclature.pdf"))
    weave(normpath(@__DIR__, "..", "src/KM620_equations.jl"); doctype = "md2pdf", out_path = normpath(@__DIR__, "..", "KM620_equations.pdf"))
    weave(normpath(@__DIR__, "..", "test/latexify_tables.jl"); doctype = "md2pdf", out_path = normpath(@__DIR__, "..", "KM620_tables.pdf"))

    rm(normpath(@__DIR__, "..", "KM620_nomenclature.aux"))
    rm(normpath(@__DIR__, "..", "KM620_nomenclature.log"))
    rm(normpath(@__DIR__, "..", "KM620_nomenclature.out"))
    rm(normpath(@__DIR__, "..", "KM620_nomenclature.tex"))
    rm(normpath(@__DIR__, "..", "KM620_equations.aux"))
    rm(normpath(@__DIR__, "..", "KM620_equations.log"))
    rm(normpath(@__DIR__, "..", "KM620_equations.out"))
    rm(normpath(@__DIR__, "..", "KM620_equations.tex"))
    rm(normpath(@__DIR__, "..", "KM620_tables.aux"))
    rm(normpath(@__DIR__, "..", "KM620_tables.log"))
    rm(normpath(@__DIR__, "..", "KM620_tables.out"))
    rm(normpath(@__DIR__, "..", "KM620_tables.tex"))

    @test isfile(normpath(@__DIR__, "..", "KM620_nomenclature.pdf"))
    @test isfile(normpath(@__DIR__, "..", "KM620_equations.pdf"))
    @test isfile(normpath(@__DIR__, "..", "KM620_tables.pdf"))
#end