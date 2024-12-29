#runtests.jl
using SGLM
using GLM
using Test
using DataFrames
using MarketData
using Dates
using TimeSeries

## Formaldehyde data from the R Datasets package
form = DataFrame([[0.1,0.3,0.5,0.6,0.7,0.9],[0.086,0.269,0.446,0.538,0.626,0.782]],
    [:Carb, :OptDen])

@testset "GLM exists test" begin
  Σ = [6.136653061224592e-05 -9.464489795918525e-05
      -9.464489795918525e-05 1.831836734693908e-04]
  lm1 = GLM.fit(LinearModel, @formula(OptDen ~ Carb), form)
  #Not retesting GLM, just making sure something comes back from GLM
  @test isa(lm1, StatsModels.TableRegressionModel)
end

@testset "Test slm" begin
  cld=DataFrame(cl)
  len=size(cld,1)
  segments=3
  cld.x=1:len
  clseg=segment(cld, segments=segments)

  @test size(clseg, 1) == segments
  @test size(clseg[1]) == (166,3)

  f=@formula(Close ~ x)
  lmv=slm(f, clseg)
  pred=getPredict(lmv)

  @test size(lmv,1) == segments
  @test size(pred,1)==len
  breakpoints=[20,40,100,234,355,423]
  clbr=segment(cld, breakpoints=breakpoints)
  @test size(clbr, 1) == length(breakpoints)+1

  ta=TimeArray(cld, timestamp=:timestamp)
  ts=segment(ta, Year)
  @test length(ts)==2
  tlm=slm(f, ts)
end