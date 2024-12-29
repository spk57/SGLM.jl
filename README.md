# SGLM
Segmented GLM

Convenience functions to segement data and leverages GLM.jl to create separate linear models. 

Leverages Generalized Linear Model (https://github.com/JuliaStats/GLM.jl) to model individual segments of a curve. </br>

## Usage
* Use `segment` to break a DataFrame or a TimeSeries into segments </br>
`function segment(df::DataFrame, segments::Int, breakpoints)` where if present breakpoints are an array of rows to use as breaks</br>
`function segment(ts:TimeSeries, period)` where period is (Year, Quarter, Month, Week)
* Use `slm` to call lm on each segment </br>
`slm(f::FormulaTerm, v::Vector)`
## Examples
* [MarketExample](docs/MarketExample.md)

Note: Under Development
