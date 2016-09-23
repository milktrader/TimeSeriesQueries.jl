julia> ex = chain(.>, Expr(:call, c, ohlc), Expr(:call, o, ohlc));
#or
julia> ex = chain(:.>, Expr(:call, :c, :ohlc), Expr(:call, :o, :ohlc));

julia> ex = chain(:log, Expr(:call, :.+, Expr(:call, :c, :ohlc), Expr(:call, :o, :ohlc)));

julia> y = Expr(:call, :when, :cl, :day, 1)
:(when(cl,day,1))

julia> eval(y)
15x1 TimeSeries.TimeArray{Float64,1,Date,Array{Float64,1}} 2000-02-01 to 2001-11-01

             Close     
             2000-02-01 | 100.25    
             2000-03-01 | 130.31    
             2000-05-01 | 124.31    
             2000-06-01 | 89.12     
             ⋮
             2001-06-01 | 20.89     
             2001-08-01 | 19.06     
             2001-10-01 | 15.54     
             2001-11-01 | 18.59     


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
         TimeSeriesQueries.gen_op(eval(s1))
         # a check of comparison is another columne or an Int/Float
         #typeof(eval(ex.args[3])) == Int || typeof(eval(ex.args[3])) == Float ?
         typeof(eval(ex.args[3])) == Int == Float ?
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
