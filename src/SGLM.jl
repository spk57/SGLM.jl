"""
Segmented General Linear Model
Convenience functions to segement data and leverages GLM.jl to create separate linear models
https://github.com/JuliaStats/GLM.jl.git
"""
module SGLM

export sglm, segment, slm

using GLM
using DataFrames
using StatsBase
using StatsModels

"""Call glm for each segment.  Returns a collection of glm results. </br>"""
#function sglm(formula::FormulaTerm, data::DataFrame, segments=1, family, link, segments=1)
#  [lm(formula, data[getRange(s), :]) for s in 1:segments]
#end

"""
Segment an array into <segments> evenly spaced segments.  
Returns a collection of <segments> views
Note: Non evenly divisible rows are included in the last segment
"""
# function segment(a::Array, segments)
#   rows=size(a,1)
#   (segLen, rem)=divrem(rows, segments)
#   firstRow(s)=1+segLen*(s-1)
#   lastRow(s)=segLen*s
#   getRange(s)= s == segments ? range(firstRow(s), lastRow(s)+rem) : range(firstRow(s), lastRow(s)) 
#   [view(a, getRange(n), : ) for n in 1:segments]
# end

"""
Segment a dataframe into <segments> evenly spaced segments.  
Returns a collection of <segments> views of dataframes
Note: Non evenly divisible rows are included in the last segment
"""
function segment(df::DataFrame, segments)
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

end # module SGLM
