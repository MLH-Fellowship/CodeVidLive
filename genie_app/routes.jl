using Dates
import Random

using Genie, Genie.Router
import Genie.Renderer.Json: json

using JuliaDB
using Distances

# Probably need to move this logic to separate files
# Struct for maps data
struct Prediction
  longitude::Float64
  latitude::Float64
  chance::Float64
end

# Struct for visualization
struct VisualPoint
  month
  noOfInfections
end

# Serializers to json
function toJson(prediction::Prediction) 
  Dict(:latitude => prediction.latitude, :longitude => prediction.longitude, :chance => prediction.chance)
end

function toJson(point::VisualPoint)
  Dict(:month => point.month, :noOfInfections => point.noOfInfections)
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
  if longitude == 0.0 || latitude == 0.0
    Dict(:message => "Longitude or latitude parameters are missing!") |> json
  else # If all validation passes
       # Return 10 points of dummy data for now
       
       # Requested latlng
       latlng = (latitude, longitude)
       
       # Load data
       data = loadtable("china-geolocation-dataset.csv")
       # Find points around requested location
       filtered_data = filter(r -> haversine((r.latitude,  r.longitude), latlng, 6372.8) < 100, data)

       # Separate NA and known data
       na_data = filter(r -> r.date_confirmation == "NA", filtered_data)
       clean_data = filter(r -> r.date_confirmation != "NA", filtered_data)

       # Date format in CSV file
       date_format = DateFormat("d.m.y")
       
       # Result of points
       points = []

       # Push NA data
       push!(points, toJson(VisualPoint("Unknown", length(na_data))))

       # Push data for each month
       months = ["December", "January", "February", "March", "April"]
       for month in months
        push!(points, toJson(VisualPoint(month, length(filter(r -> Dates.monthname(Date(r.date_confirmation, date_format)) == month, clean_data)))))
       end
       
       Dict(:points => points) |> json;
  end
end
