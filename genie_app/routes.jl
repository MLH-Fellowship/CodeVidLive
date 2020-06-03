import Dates
import Random

using Genie, Genie.Router
import Genie.Renderer.Json: json

# Probably need to move this logic to separate files
# Struct for maps data
struct Prediction
  longitude::Float64
  latitude::Float64
  chance::Float64
end

# Struct for visualization
struct VisualPoint
  date
  noOfInfections
end

# Serializers to json
function toJson(prediction::Prediction) 
  Dict(:latitude => prediction.latitude, :longitude => prediction.longitude, :chance => prediction.chance)
end

function toJson(point::VisualPoint)
  Dict(:date => point.date, :noOfInfections => point.noOfInfections)
end

route("/") do
  serve_static_file("welcome.html")
end

route("/api/prediction") do
  # Get required longitude and latitude query params
  longitude = haskey(@params, :longitude) ? parse(Float64, @params(:longitude)) : 0.0
  latitude = haskey(@params, :latitude) ? parse(Float64, @params(:latitude)) : 0.0

  # Validate params exist
  if longitude == "" || latitude == ""
    Dict(:message => "Longitude or latitude parameters are missing!") |> json
  else # If all validation passes
      # Return dummy data for now
      prediction = Prediction(longitude, latitude, 0.59)
      nearby_predictions = [Prediction(longitude, latitude, 0.59), Prediction(longitude, latitude, 0.59), Prediction(longitude, latitude, 0.59)]
      nearby_predictions_json = map(toJson, nearby_predictions);
      Dict("requested" => toJson(prediction), "nearby" => nearby_predictions_json) |> json
  end
end

route("/api/time/series") do
  # Get required longitude and latitude query params
  longitude = haskey(@params, :longitude) ? parse(Float64, @params(:longitude)) : 0.0
  latitude = haskey(@params, :latitude) ? parse(Float64, @params(:latitude)) : 0.0

  # Validate params exist
  if longitude == "" || latitude == ""
    Dict(:message => "Longitude or latitude parameters are missing!") |> json
  else # If all validation passes
       # Return 10 points of dummy data for now
      
       points = []
       today = Dates.today()
       for counter in [0:1:10;]
        push!(points, toJson(VisualPoint(today, rand(1:100))))
       end
       Dict(:points => points) |> json;
  end
end
