#' ---
#' title : KM-620 Equations
#' ---
using DataFrames, Latexify, LaTeXStrings

#' # KM-620.1 and KM-620.2
@latexrun ϵ_ts(σ_t, E_y, γ_1, γ_2, ϵ_p) =
    if (γ_1 + γ_2) <= ϵ_p
        return σ_t / E_y
    else
        return σ_t / E_y + γ_1 + γ_2
    end

#' # KM-620.3
@latexrun γ_1(ϵ_1, H) = ϵ_1 / 2 * (1 - tanh(H))

#' # KM-620.4
@latexrun γ_2(ϵ_2, H) = ϵ_2 / 2 * (1 + tanh(H))

#' # KM-620.5
@latexrun ϵ_1(σ_t, A_1, m_1) = (σ_t / A_1)^(1 / m_1)

#' # KM-620.6
@latexrun A_1(σ_ys, ϵ_ys, m_1) = σ_ys * (1 + ϵ_ys) / (log(1 + ϵ_ys))^m_1

#' # KM-620.7
@latexrun m_1(R, ϵ_p, ϵ_ys) = (log(R) + (ϵ_p - ϵ_ys)) / log(log(1+ϵ_p)/log(1+ϵ_ys))

#' # KM-620.8
@latexrun ϵ_2(σ_t, A_2, m_2) = (σ_t / A_2)^(1 / m_2)

#' # KM-620.9
@latexrun A_2(σ_uts, m_2) = (σ_uts * exp(m_2)) / (m_2^m_2)

#' # KM-620.10
@latexrun H(σ_t, σ_ys, σ_uts, K) = 2 * (σ_t - (σ_ys + K * (σ_uts - σ_ys))) / (K * (σ_uts - σ_ys))

#' # KM-620.11
@latexrun R(σ_ys, σ_uts) = σ_ys / σ_uts

#' # KM-620.12
@latexrun ϵ_ys() = 0.002

#' # KM-620.13
@latexrun K(R) = 1.5*R^1.5 - 0.5*R^2.5 - R^3.5

#' # KM-620.14
@latexrun σ_utst(σ_uts, m_2) = σ_uts * exp(m_2)

#'
#+ eval=false
"""
    plasticity(u, p)

A function in the form required to construct NonlinearSolve.jl's `IntervalNonlinearProblem`.
It will be used to find the value of `σ_t` which yields `(γ_1 + γ_2) == ϵ_p`.
This is the point defining the proportional limit and the start of plasticity `(ϵ_p, σ_p)`.

The return value is the difference between the calculated plastic strain `γ_total`
and the proportional limit `ϵ_p`.
The root (zero-crossing) of this function will be solved for in the ASME_Materials.jl package
to determine the start of the plastic stress-strain curve as defined by KM-620.
Note that the proportional limit `σ_p` determined with this method
is usually significantly lower than the material yield stress `σ_ys`
and is a more accurate starting point for the plastic stress-strain curve.

# Arguments
- `u`: some value of `σ_t`
- `p`: material parameters; must contain the following fields (which do not depend on `σ_t`):
    - `σ_ys`
    - `σ_uts`
    - `K`
    - `m_1`
    - `m_2`
    - `A_1`
    - `A_2`
    - `ϵ_p`
"""
function plasticity(u, p)
    σ_t = u                                          # Solution Variable
    (; σ_ys, σ_uts, K, m_1, m_2, A_1, A_2, ϵ_p) = p  # Parameters
    H_value   = H(σ_t, σ_ys, σ_uts, K)               # KM-620.10
    ϵ_1_value = ϵ_1(σ_t, A_1, m_1)                   # KM-620.5
    ϵ_2_value = ϵ_2(σ_t, A_2, m_2)                   # KM-620.8
    γ_1_value = γ_1(ϵ_1_value, H_value)              # KM-620.3
    γ_2_value = γ_2(ϵ_2_value, H_value)              # KM-620.4
    return γ_1_value + γ_2_value - ϵ_p  # (<= 0)     # KM-620.2
end
