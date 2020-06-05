import JSON


function read_response(
    path = "./data/sample_response_direction.json")
    response = String(read(path))
    println(response)
end

function predict(x, y, time_frame, eta)
    return eta / time_frame + (x * y)
end
