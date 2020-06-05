include("./predict.jl")
using Test

@test predict(34.1330949, -117.9143879, 33.8068768, -118.3527671, 3600) isa Number
@test predict(34.1330949, -117.9143879, 33.8068768, -118.3527671, 3600) < 1
@test predict(34.1330949, -117.9143879, 33.8068768, -118.3527671, 3600) >= 0

@test read_response() isa Dict

println("Test Successful")