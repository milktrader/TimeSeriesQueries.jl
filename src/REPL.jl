julia> ex = chain(.>, Expr(:call, c, ohlc), Expr(:call, o, ohlc));
#or
julia> ex = chain(:.>, Expr(:call, :c, :ohlc), Expr(:call, :o, :ohlc));


julia> eval(ans)
500x1 TimeSeries.TimeArray{Bool,1,Date,BitArray{1}} 2000-01-03 to 2001-12-31

             Close.>Open  
             2000-01-03 | true         
             2000-01-04 | false        
             2000-01-05 | true         
             2000-01-06 | false        
             ⋮
             2001-12-26 | true         
             2001-12-27 | true         
             2001-12-28 | true         
             2001-12-31 | false   

julia> macro bit(s1::Symbol, s2::Symbol, ex::Expr)
         # this allows column names to be expressed in the query
         gen_op(eval(s1))
         # a check of comparison is another columne or an Int/Float
         typeof(eval(ex.args[3])) == Int || typeof(eval(ex.args[3])) == Float ?
         chain(ex.args[1], Expr(:call, ex.args[2], s1), ex.args[3]) :
         chain((ex.args[1], Expr(:call, ex.args[2], s1), Expr(:call, ex.args[3], s1)))
       end

julia> @bit ohlc where Open .> Close
500x1 TimeSeries.TimeArray{Bool,1,Date,BitArray{1}} 2000-01-03 to 2001-12-31
 
                         Open.>Close  
            2000-01-03 | false        
            2000-01-04 | true         
            2000-01-05 | false        
            2000-01-06 | true         
            ⋮
            2001-12-26 | false        
            2001-12-27 | false        
            2001-12-28 | false        
            2001-12-31 | true    bit (macro with 2 methods)
