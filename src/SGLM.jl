"""
Segmented General Linear Model
Convenience functions to segement data and leverages GLM.jl to create separate linear models
https://github.com/JuliaStats/GLM.jl.git
"""
module SGLM

export sglm

using GLM
using Tables

"Call glm for each segment.  Returns a collection of glm results"
function sglm(formula, data, family, link, segments=1)
  rows=data.rows()
  (segLen, rem)=divrem(rows, segments)
  glm(formula, data, family, link) 
end

"Call glm for each segment.  Returns a collection of glm results"
#function sglm(X, y, family, link, segments=1)
  
#end

end # module SGLM
