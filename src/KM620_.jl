#' ---
#' title : KM-620
#' ---
using DataFrames, Latexify, LaTeXStrings


#' # Equations

#' **KM-620.1**
@latexrun ϵ_ts(σ_t, E_y, γ_1, γ_2) = @. σ_t / E_y + γ_1 + γ_2


#' **KM-620.2**
@latexrun γ_1(ϵ_1, H) = @. ϵ_1 / 2 * (1 - tanh(H))


#' **KM-620.3**
@latexrun γ_2(ϵ_2, H) = @. ϵ_2 / 2 * (1 + tanh(H))


#' **KM-620.4**
@latexrun ϵ_1(σ_t, A_1, m_1) = @. (σ_t / A_1)^(1 / m_1)


#' **KM-620.5**
@latexrun A_1(σ_ys, ϵ_ys, m_1) = σ_ys * (1 + ϵ_ys) / (log(1 + ϵ_ys))^m_1


#' **KM-620.6**
@latexrun m_1(R, ϵ_p, ϵ_ys) = (log(R) + (ϵ_p - ϵ_ys)) / log(log(1+ϵ_p)/log(1+ϵ_ys))


#' **KM-620.7**
@latexrun ϵ_2(σ_t, A_2, m_2) = @. (σ_t / A_2)^(1 / m_2)


#' **KM-620.8**
@latexrun A_2(σ_uts, m_2) = (σ_uts * exp(m_2)) / (m_2 ^ m_2)


#' **KM-620.9**
@latexrun H(σ_t, σ_ys, σ_uts, K) = @. 2 * (σ_t - (σ_ys + K * (σ_uts - σ_ys))) / (K * (σ_uts - σ_ys))


#' **KM-620.10**
@latexrun R(σ_ys, σ_uts) = σ_ys / σ_uts


#' **KM-620.11**
@latexrun ϵ_ys() = 0.002


#' **KM-620.12**
@latexrun K(R) = 1.5*R^1.5 - 0.5*R^2.5 - R^3.5


#' **KM-620.13**
@latexrun σ_utst(σ_uts, m_2) = σ_uts * exp(m_2)


#' # Tables

#' **Table KM-620**
const coefficients_table_forprinting = DataFrame(
        "Material" => [L"Ferritic\ steel",
                        L"Austenitic\ stainless\ steel\ and\ nickel\-based\ alloys",
                        L"Duplex\ stainless\ steel",
                        L"Precipitation\ hardening,\ nickel\ based",
                        L"Aluminum",
                        L"Copper",
                        L"Titanium\ and\ zirconium"],
        "Max. Temp. (°F)" => [900,
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

const coefficients_table = select(coefficients_table_forprinting,
                            "Material" => ByRow(unlatex) => "Material",
                            "Max. Temp. (°F)" => "Maximum Temperature (°F)",
                            L"m_2" => ByRow(x->expr2func(x,:R)) => "m_2",
                            L"m_3" => ByRow(x->expr2func(x,:El)) => "m_3",
                            L"m_4" => ByRow(x->expr2func(x,:RA)) => "m_4",
                            L"m_5" => "m_5",
                            L"\epsilon_p" => "ϵ_p"
                            )
latexify(select(coefficients_table_forprinting, 1))

#'
latexify(select(coefficients_table_forprinting, 2:7))
#' *NOTE: Ferritic steel includes carbon, low alloy, and alloy steels, and ferritic, martensitic, and iron-based age-hardening stainless steels.*


#' # Nomenclature

#' **Mandatory Appendix 1**

#' ``A_1`` = curve fitting constant for the elastic region of the stress-strain curve (KM-620)

#' ``A_2`` = curve fitting constant for the plastic region of the stress-strain curve (KM-620)

#' ``E_y`` = modulus of elasticity evaluated at the temperature of interest, see ASME Section II Part D

#' ``El`` = minimum specified elongation, %

#' ``H`` = undefined

#' ``K`` = undefined

#' ``m_1`` = undefined

#' ``m_2`` = value calculated from Table KM-620

#' ``m_3`` = value calculated from Table KM-620

#' ``m_4`` = value calculated from Table KM-620

#' ``m_5`` = value listed in Table KM-620

#' ``R`` = Sy/Su

#' ``RA`` = minimum specified reduction of area, %

#' ``γ_1`` = true strain in the micro-strain region of the stress-strain curve (KM-620)

#' ``γ_2`` = true strain in the macro-strain region of the stress-strain curve (KM-620)

#' ``ϵ_p`` = stress-strain curve fitting parameter (KM-620)

#' ``ϵ_{ts}`` = true total strain (KM-620)

#' ``ϵ_{ys}`` = 0.2% engineering offset strain (KM-620)

#' ``ϵ_1`` = true plastic strain in the micro-strain region of the stress-strain curve (KM-620)

#' ``ϵ_2`` = true plastic strain in the macro-strain region of the stress-strain curve (KM-620)

#' ``σ_t`` = true stress at which the true strain will be evaluated (KM-620)

#' ``σ_{uts}`` = engineering ultimate tensile stress evaluated at the temperature of interest (KM-620)

#' ``σ_{ys}`` = engineering yield stress evaluated at the temperature of interest (KM-620)

#' ``σ_{utst}`` = true ultimate tensile stress evaluated at the true ultimate tensile strain
