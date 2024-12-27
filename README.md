# SGLM
Segmented GLM

Convenience functions to segement data and leverages GLM.jl to create separate linear models. 

Leverages Generalized Linear Model (https://github.com/JuliaStats/GLM.jl) to model individual segments of a curve. </br>

## Usage
* Use `segment` to break a DataFrame into equal length Segments </br>
`function segment(df::DataFrame, segments::Int)`
* Use `slm` to call lm on each segment </br>
`slm(f::FormulaTerm, v::Vector)`
## Examples
* [MarketExample](docs/MarketExample.md)

Note: Under Development
