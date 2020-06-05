using HTTP
using JSON
function get_eta(longitude::Float64, latitude::Float64, longitude2::Float64, latitude2::Float64) 
    r = HTTP.request("GET", "https://api.mapbox.com/directions/v5/mapbox/driving/$longitude%2C$latitude%3B$longitude2%2C$latitude2?alternatives=false&geometries=geojson&steps=false&access_token=pk.eyJ1IjoiZGlhZ2EiLCJhIjoiY2them1jMGY1MGI1YjJ6bG8yZHlnd2trNSJ9.FSly4QvdXoFjVlqXldieew")
    j = JSON.parse(String(r.body))
    eta = j["routes"][1]["legs"][1]["duration"]
    open("./data/foo.json", "a") do f 
        JSON.print(f, j)
    end
    return eta
end
