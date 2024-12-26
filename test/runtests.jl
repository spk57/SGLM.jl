#runtests.jl
using SGLM
using GLM
using Test
using DataFrames
using MarketData
using Dates

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

@testset "Test Segmentation" begin
  cld=DataFrame(cl)
  cld.ts=Dates.value.(cld.timestamp)
  cld2=select!(cld, Not([:timestamp]))
  clm=Matrix(cld2)
  s3=segment(clm, 3)
  @test size(s3, 1) == 3
  @test size(s3[1]) == (166,2)
end