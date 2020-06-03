using Genie, Genie.Router
import Genie.Renderer.Json: json

# Probably need to move this logic to separate files
struct Prediction
  longitude::Float64
  latitude::Float64
  chance::Float64
end

function toJson(prediction::Prediction) 
  Dict(:latitude => prediction.latitude, :longitude => prediction.longitude, :chance => prediction.chance)
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
    (:message => "Longitude or latitude parameters are missing!") |> json
  else # If all validation passes
      # Return dummy data for now
      prediction = Prediction(longitude, latitude, 0.59)
      nearby_predictions = [Prediction(longitude, latitude, 0.59), Prediction(longitude, latitude, 0.59), Prediction(longitude, latitude, 0.59)]
      nearby_predictions_json = map(toJson, nearby_predictions);
      ("requested" => toJson(prediction), "nearby" => nearby_predictions_json) |> json
  end
end
