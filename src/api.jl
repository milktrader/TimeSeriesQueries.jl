# run gen_op(ohlc) before calling this macro

# julia> @select ohlc where Open .> 100
# julia> @select ohlc where Open .> Close
# julia> @select ohlc where Open .> 100 when dayname "Friday"
# julia> @select ohlc where Open .> Close when month 2

macro select(s1::Symbol, s2::Symbol, ex::Expr)
    # a check of comparison is another columne or an Int/Float
    typeof(eval(ex.args[3])) == Int || typeof(eval(ex.args[3])) == Float64 ?
    # limit of two scenarios
    chain(ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), ex.args[3]) :
    chain(ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), Expr(:call, ex.args[3], esc(:($s1))))
end

macro select(s1::Symbol, s2::Symbol, ex::Expr, s3::Symbol, s4::Symbol, str::String)
    # a check of comparison is another columne or an Int/Float
    typeof(eval(ex.args[3])) == Int || typeof(eval(ex.args[3])) == Float64 ?
    # limit of two scenarios
    chain(:when, Expr(:call, ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), ex.args[3]), s4, str) :
    chain(:when, Expr(:call, ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), Expr(:call, ex.args[3], esc(:($s1)))), s4, str)
end

macro select(s1::Symbol, s2::Symbol, ex::Expr, s3::Symbol, s4::Symbol, num::Int)
    # a check of comparison is another columne or an Int/Float
    typeof(eval(ex.args[3])) == Int || typeof(eval(ex.args[3])) == Float64 ?
    # limit of two scenarios
    chain(:when, Expr(:call, ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), ex.args[3]), s4, num) :
    chain(:when, Expr(:call, ex.args[1], Expr(:call, ex.args[2], esc(:($s1))), Expr(:call, ex.args[3], esc(:($s1)))), s4, num)
end
