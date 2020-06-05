include("./predict.jl")
using Test
@test predict(0, 0, 60, 60) == 1