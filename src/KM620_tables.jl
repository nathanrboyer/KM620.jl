#' ---
#' title : Table KM-620
#' ---
using CSV, DataFrames, Latexify, LaTeXStrings

"""
    expr2func(expr::Expr, var::Symbol) -> func::Function

Creates an anonymous function from an expression `expr`.
`var` must match the variable used in `expr`
and be the only variable used in `expr`.

# Examples
```julia-repl
julia> f = expr2func(:(z + 2), :z)
#1 (generic function with 1 method)

julia> f(3)
5
```
"""
function expr2func(expr::Expr, var::Symbol)
    func = eval(:($var -> $expr))
end

"""
    ln_to_log(s::AbstractString)

Julia uses log(x) for natural logarithm.
There is no `ln` function, so must transform strings containing ln() to use log() instead.
If input is not a string, then input is returned as is.
"""
ln_to_log(s::AbstractString) = replace(s, "ln(" => "log(")
ln_to_log(s) = s # Do nothing if not a string.

"""
    parse_table_KM620(path::AbstractString)

Read Table KM-620 from CSV file `path` into a DataFrame and parse the functions into expressions.
"""
function parse_table_KM620(path::AbstractString)
    df = DataFrame(CSV.File(path))
    transform!(df, All() .=> ByRow(ln_to_log), renamecols=false)
    transform!(df, "m₂" => ByRow(Meta.parse), renamecols=false)
    transform!(df, "m₃" => ByRow(Meta.parse), renamecols=false)
    transform!(df, "m₄" => ByRow(Meta.parse), renamecols=false)
    metadata!(df, "Note 1", "(1) Ferritic steel includes carbon, low alloy, and alloy steels, and ferritic, martensitic, and iron-based age-hardening stainless steels.", style=:note)
    return df
end

const coefficients_table_for_printing = parse_table_KM620(normpath(@__DIR__, "..", "Table KM-620.csv"))

const coefficients_table = transform(
    coefficients_table_for_printing,
    "m₂" => ByRow(x->expr2func(x,:R)),
    "m₃" => ByRow(x->expr2func(x,:El)),
    "m₄" => ByRow(x->expr2func(x,:RA)),
    renamecols=false,
)
