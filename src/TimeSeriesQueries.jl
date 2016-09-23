VERSION >= v"0.4.0-dev+6521" && __precompile__(true)

module TimeSeriesQueries

using TimeSeries

export @select,  # @s, @f, @bit,
       # parseit,
       chain, gen_op

include("api.jl")
include("meta_utilities.jl")

end
