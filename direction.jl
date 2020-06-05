using HTTP
using JSON
using Dates

function toJson(longitude::Float64, latitude::Float64, longitude2::Float64, latitude2::Float64, _time::DateTime) 
  r = HTTP.request("GET", "https://api.mapbox.com/directions/v5/mapbox/driving/$longitude%2C$latitude%3B$longitude2%2C$latitude2?alternatives=false&geometries=geojson&steps=false&access_token=")
  j = JSON.parse(String(r.body))
  open("./data/foo.json","a") do f 
    JSON.print(f, j)
  end 
  eta = _time + Dates.Second(Int(round(j["routes"][1]["legs"][1]["duration"])))
  print(Dates.format(eta, "HH:MM:SS"))
  return eta
end
