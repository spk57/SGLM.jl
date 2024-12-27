# SGLM
Segmented GLM

Convenience functions to segement data and leverages GLM.jl to create separate linear models. 

Leverages Generalized Linear Model (https://github.com/JuliaStats/GLM.jl) to model individual segments of a curve. </br>

## Usage
* Use `segment` to break a DataFrame into equal length Segments
* Use `slm1` to call lm on each segment 

## Examples
* [MarketData](./examples/MarketData.md)

Note: Under Development
