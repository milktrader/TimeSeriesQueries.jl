VERSION >= v"0.4.0-dev+6521" && __precompile__(true)

module TimeSeriesQueries

using TimeSeries

export @select, @s,
       parseit

include("api.jl")

end
