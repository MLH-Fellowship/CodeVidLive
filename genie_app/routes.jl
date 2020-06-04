import Dates
import Random

using Genie, Genie.Router
import Genie.Renderer.Json: json
using Genie.Requests
using HTTP

using CSV

df = CSV.read("./US_State_Final_data.csv", normalizenames = true)

struct Prediction
  date
  state::String
  totalInfection::Int64
  dailyInfection::Int64
  longitude::Float64
  latitude::Float64
  chance::Float64
end

function toJson(prediction::Prediction) 
  Dict(:date => prediction.date, :state=> prediction.state, :totalInfection=> prediction.totalInfection, :dailyInfection=> prediction.dailyInfection, :longitude=> prediction.longitude, :latitude=> prediction.latitude, :chance=> prediction.chance)
end

Genie.config.run_as_server = true

route("/") do
  serve_static_file("welcome.html")
end

route("/api/prediction",method = POST ) do
  dummy = 0
  points = []
       for i in 1:size(df,1)
        push!(points, toJson(Prediction(df[i,2], df[i,3],df[i,4],df[i,5],df[i,6],df[i,7],dummy)))
        
        end
       
  Dict(:points => points) |> json;
end

Genie.startup(async = false)