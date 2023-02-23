#' ---
#' title : KM-620 Tables
#' ---
using DataFrames, Latexify, LaTeXStrings, KM620

#' # Table KM-620
latexify(select(KM620.coefficients_table_for_printing, 1), latex=false)

#'
latexify(select(KM620.coefficients_table_for_printing, 2:7))
#' *NOTE: Ferritic steel includes carbon, low alloy, and alloy steels, and ferritic, martensitic, and iron-based age-hardening stainless steels.*
