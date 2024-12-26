"""
Segmented General Linear Model
Convenience functions to segement data and leverages GLM.jl to create separate linear models
https://github.com/JuliaStats/GLM.jl.git
"""
module SGLM

export sglm

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
function segment(a::Array, segments)
  rows=size(a,1)
  (segLen, rem)=divrem(rows, segments)
  firstRow(s)=1+segLen*(s-1)
  lastRow(s)=segLen*s
  getRange(s)= s == segments ? range(firstRow(s), lastRow(s)+rem) : range(firstRow(s), lastRow(s)) 
  [view(a, getRange(n), : ) for n in 1:segments]
end

"""Call lm for each segment.  Returns a collection of glm results
 CX and Cy are collections of matrices of the independant and dependant variables
"""
function slm(CX::Vector, Cy::Vector, wts=wts)
  for r in 1:size(CX,1)
    fit(LinearModel, CX[r,:], y[r,:])
  end
end

end # module SGLM
