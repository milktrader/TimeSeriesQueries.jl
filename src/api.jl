macro select(ex1::Expr, sym1::Symbol, ex2::Expr, sym2::Symbol, ex3::Expr)

    if sym1 != :where || sym2 != :when
        error("check the syntax or order of filter statements")
    else
        data_sym  = parseit(ex1.args)
        where_sym = ex2.args
        when_sym  = ex3.args
    end
    
    # the queryable object
    data = eval(last(data_sym))

    # lower case the column names
    lower_colnames = data.colnames
    for n in 1:length(lower_colnames)
        lower_colnames[n] = lowercase(lower_colnames[n])
    end

    # rename data.colnames to all lower case
    rename(data, lower_colnames)

    # define variables by their column names
    cols = data_sym[1:end-1]
    
    # this assigns foo() to data[lowercase(string(:foo)]
    # this is a hack to assign a function to what I'd prefer were a variable, but let's see
    for c in cols
        @eval begin
            ($c)() = data[lowercase(string($c))]
        end
    end

    return cols[1]() .> cols[2]()

end

#@select Open, High, Low in cl

function parseit(x::Array)

    # TODO
    # error check that :in is in the array

    if last(x).args == 1
        return x
    else
        return vcat(x[1:length(x)-1], last(x).args[2:end] )
    end
end

# julia> @select open, high, close in ohlcv where open > close && close < high when day == Friday
# (Any[:open,:high,:(close in ohlcv)],:where,Any[:(open > close),:(close < high)],:when,Any[:(==),:day,:Friday])

# @take :Open, :Close in ohlc
# @where :Open > :Close
# @when day == Friday

# @select open, high, close
# @from ohlcv
# @where open > close
# @when day = Tuesday

## macro column(ex::Expr)
##     x = ex.args[3]
##     eval(x)[string(ex.args[2])]
## end
## 
## macro where()
##     println("I am the where macro")
## end
## 
## macro when()
##     println("I am the when macro")
## end
## 
## macro collect()
##     println("I am the collect macro")
## end
## 
## #function query{T.N}(sym::Array{Symbol}, ta::TimeArray{T,N}, where::TimeArray{Bool,1}, when::TimeArray{Bool,1})
## function query{T.N}(sym::Array{Symbol}, ta::TimeArray{T,N}, where::TimeArray{Bool,1}, when::TimeArray{Bool,1})
## 
##     # convert symbols to strings to index the timearray ta
##     idx = String[]
##     for s in sym
##         push!(idx, string(s))
##     end
## 
##     # queriable timearray columned is constructed
##     # TODO make this more efficient
##     columned = ta[idx[1]]
##     for i in 2:size(idx,1)
##         columned = merge(columned, ta[idx[i]])
##     end
## end


