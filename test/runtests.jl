#runtests.jl
using SGLM
using GLM
using Test
using DataFrames


## Formaldehyde data from the R Datasets package
form = DataFrame([[0.1,0.3,0.5,0.6,0.7,0.9],[0.086,0.269,0.446,0.538,0.626,0.782]],
    [:Carb, :OptDen])

@testset "Base tests" begin
  Σ = [6.136653061224592e-05 -9.464489795918525e-05
      -9.464489795918525e-05 1.831836734693908e-04]
  lm1 = GLM.fit(LinearModel, @formula(OptDen ~ Carb), form)
  #Not retesting GLM, just making sure something comes back from GLM
  @test isa(lm1, StatsModels.TableRegressionModel)
end
