import JSON



function read_response(
    path = "./data/sample_response_direction.json"
    )
    response = String(read(path))
    response_json = JSON.parse(response)
    return response_json
end

function predict(clustor_lat, clustor_lng, lat, lng, time_frame)
    virus_factor = rand(1:100) / 100
    response = read_response()
    route = first(response["routes"])
    leg = first(route["legs"])
    eta = leg["duration"]["value"]
    return eta * virus_factor / time_frame 
end
