# run gen_op(ohlc) before calling this macro
# note that Open() will be defined in REPL as TimeSeriesQueries.Open()

# julia> @select ohlc where Open
macro select(s1::Symbol, s2::Symbol, s3::Symbol)
    Expr(:call, s3, esc(:($s1)))
end

# julia> @select ohlc when monthname "October"
macro select(s1::Symbol, s2::Symbol, s3::Symbol, str::String)
    Expr(:call, :when, esc(:($s1)), s3, str)
end

# julia> @select ohlc when year 2000
macro select(s1::Symbol, s2::Symbol, s3::Symbol, num::Int)
    Expr(:call, :when, esc(:($s1)), s3, num)
end

# julia> @select AAPL where Open when monthname "January"
macro select(s1::Symbol, s2::Symbol, s3::Symbol, s4::Symbol, s5::Symbol,  str::String)
    chain(s3, Expr(:call, :when, esc(:($s1)), s5, str))
end

# julia> @select AAPL where Open when year 2000
macro select(s1::Symbol, s2::Symbol, s3::Symbol, s4::Symbol, s5::Symbol,  num::Int)
    chain(s3, Expr(:call, :when, esc(:($s1)), s5, num))
end

# julia> @select ohlc where Open .> 100 (or .> Close)
macro select(s1::Symbol, s2::Symbol, ex::Expr)
    # a check of comparison is another columne or an Int/Float
    typeof(eval(ex.args[3])) == Int || typeof(eval(ex.args[3])) == Float64 ?
    # limit of two scenarios
    chain(ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), ex.args[3]) :
    chain(ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), Expr(:call, ex.args[3], esc(:($s1))))
end

# julia> @select ohlc where Open .> 100 when dayname "Friday"
macro select(s1::Symbol, s2::Symbol, ex::Expr, s3::Symbol, s4::Symbol, str::String)
    # a check of comparison is another columne or an Int/Float
    typeof(eval(ex.args[3])) == Int || typeof(eval(ex.args[3])) == Float64 ?
    # limit of two scenarios
    chain(:when, Expr(:call, ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), ex.args[3]), s4, str) :
    chain(:when, Expr(:call, ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), Expr(:call, ex.args[3], esc(:($s1)))), s4, str)
end

# julia> @select ohlc where Open .> Close when month 2
macro select(s1::Symbol, s2::Symbol, ex::Expr, s3::Symbol, s4::Symbol, num::Int)
    # a check of comparison is another columne or an Int/Float
    typeof(eval(ex.args[3])) == Int || typeof(eval(ex.args[3])) == Float64 ?
    # limit of two scenarios
    chain(:when, Expr(:call, ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), ex.args[3]), s4, num) :
    chain(:when, Expr(:call, ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), Expr(:call, ex.args[3], esc(:($s1)))), s4, num)
end
