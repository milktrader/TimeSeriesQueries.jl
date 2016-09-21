macro s(ta::Symbol)
#    esc(ta)

    #esc(ta).colnames #ERROR: type Expr has no field colnames
    #esc(eval(ta.colnames)) #ERROR: type Symbol has no field colnames
    #esc(eval(ta).colnames) #ERROR: UndefVarError: cl not defined
    #esc(eval($ta).colnames) #ERROR: error compiling @s: syntax: prefix "$" in non-quoted expression
    #esc(eval(:($ta)).colnames) #ERROR: UndefVarError: cl not defined
    #colnames(esc(ta)) #ERROR: MethodError: no method matching colnames(::Expr)
    #esc(colnames(esc(ta))) #ERROR: MethodError: no method matching colnames(::Expr)
    #esc(colnames(ta)) #ERROR: MethodError: no method matching colnames(::Symbol)
    #esc(colnames(eval(ta))) #ERROR: UndefVarError: cl not defined
    #esc(colnames(esc(eval(ta)))) #ERROR: UndefVarError: cl not defined
    #esc(colnames(esc(eval(:($ta))))) #ERROR: UndefVarError: cl not defined
    #quote
    #    local bar = esc($ta)
    #    return esc(colnames(bar))
    #end #ERROR: UndefVarError: cl not defined
    #exp1 = :(ta.colnames) #ERROR: UndefVarError: ta not defined
    #exp1 = :($ta.colnames) #ERROR: UndefVarError: ta not defined
      return esc(:($ta.colnames)) # WORKS!
end

macro select(ex1::Expr, sym1::Symbol, ex2::Expr, sym2::Symbol, ex3::Expr)

####################    if sym1 != :where || sym2 != :when 
####################        error("check the syntax or order of filter statements")
####################    end

#    quote
#        data_sym  = parseit($ex1.args)
        data_sym  = parseit(ex1.args)
       # where_sym = ex2.args
#        where_sym = $ex2.args
       # when_sym  = ex3.args
#        when_sym  = $ex3.args
       # sym       = last(data_sym)
        sym       = last(data_sym)
        #data = esc(last(data_sym))

#    cols = esc(last(data_sym)).colnames

        #return esc(data.colnames)
        #return esc(data)
        #return data
        #return eval(data)["Open"]

   ############   return esc(:($sym.colnames)) # WORKS!
  ###############   return esc(:($sym["Open"])) # WORKS!
  foo = rename(esc(:($sym)),["foo"])# WORKS!
  return esc(foo)# WORKS!

#    end
 
#####      # lower case the column names
#####      #lower_colnames = data.colnames
#    lower_colnames = :($sym.colnames)
        #for n in 1:length(lower_colnames)
###    for n in 1:5
###         #lower_colnames[n] = lowercase(lower_colnames[n])
###         #:($sym.colnames[n]) = lowercase(:($sym.colnames[n]))
###         lowercase(esc(:($sym.colnames[n])))
###     end

#   local foo = esc(:($sym.colnames)) # WORKS!
#   local bar = esc(:($sym.colnames[1])) # WORKS!
#   local baz = lowercase(bar)
#
#   return esc(:($baz))
   
#   end


#####  
#####      # rename data.colnames to all lower case
#####      rename(data, lower_colnames)
# 
#     # define variables by their column names
#     cols = data_sym[1:end-1]
#     
#     # this assigns foo() to data[lowercase(string(:foo)]
#     # this is a hack to assign a function to what I'd prefer were a variable, but let's see
# #     for c in cols
# #         @eval begin
# #             ($c)() = data[lowercase(string($c))]
# #         end
# #     end
# # 
# #     return cols[1]() .> cols[2]()
# 
# #end
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
