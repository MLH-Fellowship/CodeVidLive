module GenieApp

using Logging, LoggingExtras

function main()
  Base.eval(Main, :(const UserApp = GenieApp))

  include(joinpath("..", "genie.jl"))

  Base.eval(Main, :(const Genie = GenieApp.Genie))
  Base.eval(Main, :(using Genie))
end; main()

end
