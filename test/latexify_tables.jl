#' ---
#' title : KM-620 Tables
#' ---
using DataFrames, Latexify, LaTeXStrings, PrettyTables
import KM620

#+ results="hidden"
function beautify(df::DataFrame)
    bdf = copy(df)
    for col in names(bdf) # latexify all expressions
        if eltype(bdf[!, col]) === Expr
            transform!(bdf, col => ByRow(latexify), renamecols=false)
        end
    end
    header = [L"Material", L"Max.\ Temp.", L"m_2", L"m_3", L"m_4", L"m_5", L"\epsilon_p"]
    return pretty_table(bdf, backend=Val(:latex), header = header)
end

#' # Table KM-620
#+ results="tex"
beautify(KM620.coefficients_table_for_printing)

#' NOTE:
#+ wrap=false
println.(values(metadata(KM620.coefficients_table_for_printing)));
