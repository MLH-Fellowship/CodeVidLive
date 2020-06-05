import JSON


function read_response(
    path = "./data/sample_response_direction.json")
    response = String(read(path))
    println(response)
    return response
end

function predict(clustor_lat, clustor_lng, lat, lng, time_frame)
    virus_factor = rand(1:100) / 100
    eta = abs(lat - clustor_lat + lng - clustor_lng)
    return eta * virus_factor / time_frame 
end
