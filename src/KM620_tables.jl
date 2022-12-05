#' ---
#' title : Table KM-620
#' ---
using DataFrames, Latexify, LaTeXStrings

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
    unlatex(s::LaTeXString) -> s::String
Removes `\$` and `\\` characters from a string `s`.
"""
function unlatex(s::LaTeXString)
    replace(s, "\$"=>"", "\\"=>"")
end

const coefficients_table_forprinting = DataFrame(
        L"Material" => ["Ferritic steel",
                        "Austenitic stainless steel and nickel-based alloys",
                        "Duplex stainless steel",
                        "Precipitation hardening, nickel based",
                        "Aluminum",
                        "Copper",
                        "Titanium and zirconium"],
        L"Max.\ Temp.\ (F)" => [900,
                                900,
                                900,
                                1000,
                                250,
                                150,
                                500],
        L"m_2" => [:(0.60 * (1.00 - R)),
                :(0.75 * (1.00 - R)),
                :(0.70 * (0.95 - R)),
                :(1.09 * (0.93 - R)),
                :(0.52 * (0.98 - R)),
                :(0.50 * (1.00 - R)),
                :(0.50 * (0.98 - R))],
        L"m_3" => [:(2*log(1+(El/100))),
                :(3*log(1+(El/100))),
                :(2*log(1+(El/100))),
                :(1*log(1+(El/100))),
                :(1.3*log(1+(El/100))),
                :(2*log(1+(El/100))),
                :(1.3*log(1+(El/100)))],
        L"m_4" => [:(log(100 / (100 - RA))),
                :(log(100 / (100 - RA))),
                :(log(100 / (100 - RA))),
                :(log(100 / (100 - RA))),
                :(log(100 / (100 - RA))),
                :(log(100 / (100 - RA))),
                :(log(100 / (100 - RA)))],
        L"m_5" => [2.2,
                0.6,
                2.2,
                2.2,
                2.2,
                2.2,
                2.2],
        L"\epsilon_p" => [2.0E-5,
                2.0E-5,
                2.0E-5,
                2.0E-5,
                5.0E-6,
                5.0E-6,
                2.0E-5])

const coefficients_table = select(coefficients_table_forprinting,
                            L"Material" => "Material",
                            L"Max.\ Temp.\ (F)" => "Maximum Temperature (°F)",
                            L"m_2" => ByRow(x->expr2func(x,:R)) => "m_2",
                            L"m_3" => ByRow(x->expr2func(x,:El)) => "m_3",
                            L"m_4" => ByRow(x->expr2func(x,:RA)) => "m_4",
                            L"m_5" => "m_5",
                            L"\epsilon_p" => "ϵ_p"
                            )

# Should be able to make the table header say L"Max.\ Temp.\ (\degree F)" instead once Weave issues are fixed.
# https://github.com/JunoLab/Weave.jl/issues/392
# https://github.com/JunoLab/Weave.jl/issues/418
