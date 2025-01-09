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
using TimeSeries
using Dates

"Combine TimeSeries From and To"
fromTo(ta, f, t)=to(from(ta, f), t)

"Get the first day of the period"
function firstDay(d, period)
  d = if period==Year 
    Dates.firstdayofyear(d)
  elseif period == Quarter
    Dates.firstdayofquarter(d)
  elseif period == Month
    Dates.firstdayofmonth(d)
  elseif period == Week
    Dates.firstdayofweek(d)
  else throw("Date adjuster function not found:  $period")
  end
end

"""
Segment a TimeSeries into `segments` by time grouping
"""
function segment(ta::TimeArray, period=Year)  
  firstDate=firstDay(timestamp(ta[1])[1], period)
  lastDate =timestamp(ta[end])[1]
  tr=firstDate:period(1):lastDate
  [fromTo(ta, p, p+period(1)-Day(1)) for p in tr]
end

"""
Segment a dataframe into `segments` evenly spaced segments or broken at breakpoints
Returns a collection of `segments` views of dataframes
Note: If length of df is not evenly divisible, the remaining rows are included in the last segment
breakpoints indiciate the first row of a new segment
"""
function segment(df::DataFrame; segments=1, breakpoints=missing)
  rows=size(df,1)
  (segLen, rem)=divrem(rows, segments)
  firstRow(s)=1+segLen*(s-1)
  lastRow(s)=segLen*s
  nBreaks=!ismissing(breakpoints) && length(breakpoints) > 1 ? length(breakpoints) : 1
  getRange(s)= s == segments ? range(firstRow(s), lastRow(s)+rem) : range(firstRow(s), lastRow(s)) 
  nextRange(s, bp)=range(bp[s-1], bp[s]-1)
  if nBreaks > 1
    bp=copy(breakpoints)
    bp[1] != 1 ? pushfirst!(bp,1) : nothing #Add first and last rows if not included
    bp[end] != rows ? push!(bp,rows+1) : nothing
    [view(df, nextRange(n, bp), :) for n in 2:length(bp)]
  else
    [view(df, getRange(n), : ) for n in 1:segments]
  end
end

"""Call lm for each segment.  Returns a collection of glm results
v is a Vector of DataFrames
"""
function slm(f::FormulaTerm, v::Vector)
  if isa(v[1], AbstractDataFrame)
    return [lm(f, df) for df in v]
  elseif isa(v[1], AbstractTimeSeries)
    return [lm(f, DataFrame(ts)) for ts in v]
  else throw("Illegal datatype in Vector $(typeof(v[1]))")
  end
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
