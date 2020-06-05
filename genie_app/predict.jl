import JSON
include("./direction.jl")


function read_response(
    path = "./data/sample_response_direction.json"
    )
    response = String(read(path))
    response_json = JSON.parse(response)
    return response_json
end

function neuts_and_li(distance, routes, interaction_degree)
    return distance * routes^interaction_degree
end


function predict(clustor_lat, clustor_lng, lat, lng, time_frame, risk_function_type = "random")
    if risk_function_type == "random"
        virus_factor = rand(1:100) / 100
    end
    if risk_function_type == "neuts_and_li"
        virus_factor = neuts_and_li(100, 2, 0.2)
    end
    eta = get_eta(clustor_lng, clustor_lat, lng, lat)
    return eta * virus_factor / time_frame 
end
