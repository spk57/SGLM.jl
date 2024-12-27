"""
Segmented General Linear Model
Convenience functions to segement data and leverages GLM.jl to create separate linear models
https://github.com/JuliaStats/GLM.jl.git
"""
module SGLM

export segment, unsegment, slm, getPredict, getResiduals, getCoef, getDeviance

using GLM
using DataFrames
using StatsBase
using StatsModels
using Plots

"""
Segment a dataframe into <segments> evenly spaced segments.  
Returns a collection of <segments> views of dataframes
Note: Non evenly divisible rows are included in the last segment
"""
function segment(df::DataFrame, segments::Int)
  rows=size(df,1)
  (segLen, rem)=divrem(rows, segments)
  firstRow(s)=1+segLen*(s-1)
  lastRow(s)=segLen*s
  getRange(s)= s == segments ? range(firstRow(s), lastRow(s)+rem) : range(firstRow(s), lastRow(s)) 
  [view(df, getRange(n), : ) for n in 1:segments]
end

"""Call lm for each segment.  Returns a collection of glm results
 CX and Cy are collections of matrices of the independant and dependant variables
"""
function slm(f::FormulaTerm, v::Vector)
  [lm(f, df) for df in v]
end

"Recombine segments into 1 prediction matrix"
getPredict(s)=mapreduce(predict, vcat, s)
"Recombine segments into 1 residual matrix"
getResiduals(s)=mapreduce(residuals, vcat, s)

"Get a vector of coefficients"
getCoef(s::Vector)=map(coef, s)
"Get a vector of deviance values"
getDeviance(s)=mapreduce(deviance, vcat, s)
end # module SGLM
