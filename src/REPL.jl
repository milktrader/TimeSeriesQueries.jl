julia> ex = chain(.>, Expr(:call, c, ohlc), Expr(:call, o, ohlc));

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
