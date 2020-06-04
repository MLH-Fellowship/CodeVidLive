# Required packages
using Distances,
      Pathogen,
      Random,
      Plots,
      Plots.PlotMeasures; # Plots.PlotMeasures is used for advanced formatting control for figure output

println("hello world")# Set seed
Random.seed!(11235);

n = 100
risks = DataFrame(x = rand(Uniform(0, 15), n),
                  y = rand(Uniform(0, 30), n),
                  riskfactor1 = rand(Gamma(), n))

# Precalculate distances
dists = [euclidean([risks[i, :x];
                    risks[i, :y]],
                   [risks[j, :x];
                    risks[j, :y]]) for i = 1:n, j = 1:n]

pop = Population(risks, dists)

println(pop)

# Define risk functions/TN-ILM structure
function _constant(θ::Vector{Float64}, pop::Population, i::Int64)
    return θ[1]
end
  
function _one(θ::Vector{Float64}, pop::Population, i::Int64)
    return 1.0
end
  
function _linear(θ::Vector{Float64}, pop::Population, i::Int64)
    return θ[1] * pop.risks[i, :riskfactor1]
end
  
function _powerlaw(θ::Vector{Float64}, pop::Population, i::Int64, k::Int64)
    d = pop.distances[k, i]
    return d^(-θ[1])
end
  
rf = RiskFunctions{SIR}(_constant, # sparks function
                          _one, # susceptibility function
                          _powerlaw, # infectivity function
                          _one, # transmissability function
                          _linear) # removal function
  
  # Parametrize risk functions for simulation
rparams = RiskParameters{SIR}([0.0001], # sparks function parameter(s)
                                Float64[], # susceptibility function parameter(s)
                                [4.0], # infectivity function parameter(s)
                                Float64[], # transmissibility function parameter(s)
                                [0.1]) # removal function parameter(s)

                                
# Set starting states in population
# Set first individual as infectious, others as susceptible to start
starting_states = [State_I; fill(State_S, n - 1)]

# Initialize Simulation
sim = Simulation(pop, starting_states, rf, rparams)

# Simulate!
simulate!(sim, tmax = 200.0)

gr(dpi = 200) # GR backend with DPI = 200

# Epidemic Curve
p1 = plot(sim.events, 0.0, 200.0, legendfont = font(6), xaxis = font(10), bottom_margin = 30px)

# Population/TransmissionNetwork plots
p2 = plot(sim.transmission_network, sim.population, sim.events, 0.0, title = "Time = 0", titlefontsize = 8)
p3 = plot(sim.transmission_network, sim.population, sim.events, 10.0, title = "Time = 10", titlefontsize = 8)
p4 = plot(sim.transmission_network, sim.population, sim.events, 20.0, title = "Time = 20", titlefontsize = 8)
p5 = plot(sim.transmission_network, sim.population, sim.events, 30.0, title = "Time = 30", titlefontsize = 8)
p6 = plot(sim.transmission_network, sim.population, sim.events, 50.0, title = "Time = 50", titlefontsize = 8)

l = @layout [a
             grid(1, 5)]
combinedplots1 = plot(p1, p2, p3, p4, p5, p6, layout = l)
png(combinedplots1, joinpath(@__DIR__, "epiplot.png"))

# Transmission animation
anim = @animate for simtime = range(0.0, 200.0, step = 1.0)
    p1 = plot(sim.transmission_network, sim.population, sim.events, simtime, markersize = 4, legend = :none, xlim = (-2, 17))
    p2 = plot([simtime], [1.0], seriestype = :scatter, markercolor = :black, markersize = 4, marker = :dtriangle, legend = :none, xlabel = "Time", framestyle = :origin, grid = :none, tick_direction = :out, yaxis = false, xticks = 0:25:200, aspect_ratio = 4, ylim = (-1, 1), xlim = (-10, 210), xaxis = font(8))
    l = @layout [a{0.975h}; b]   
    plot(p1, p2, layout = l)
end
gif(anim, joinpath(@__DIR__, "epianimation.gif"), fps = 20);