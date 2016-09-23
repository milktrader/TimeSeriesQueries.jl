function chain(op1, op2...)
    Expr(:call, op1, op2...)
end

function gen_op(ta::TimeArray)
    cols = ta.colnames
    box  = Any[]
    for c in cols
        push!(box, (Symbol(c), c))
    end
    for (fn, name) in box
        @eval begin
            function $fn(ta)
                ta[$name]
            end
        end
    end
end
