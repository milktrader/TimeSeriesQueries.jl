using MarketData
FactCheck.setstyle(:compact)
FactCheck.onlystats(true)

facts("generation of operators") do

    gen_op(ohlc)

    context("Open method") do
        @fact TimeSeriesQueries.Open(ohlc).colnames --> ["Open"]
        @fact length(TimeSeriesQueries.Open(ohlc))  --> 500
    end

    context("High method") do
        @fact TimeSeriesQueries.High(ohlc).colnames --> ["High"]
        @fact length(TimeSeriesQueries.High(ohlc))  --> 500
    end

    context("Low methods") do
        @fact TimeSeriesQueries.Low(ohlc).colnames --> ["Low"]
        @fact length(TimeSeriesQueries.Low(ohlc))  --> 500
    end

    context("Close method") do
        @fact TimeSeriesQueries.Close(ohlc).colnames --> ["Close"]
        @fact length(TimeSeriesQueries.Close(ohlc))  --> 500
    end
end
facts("chaining operations") do

    logres = chain(:log, Expr(:call, :exp, :op))
    divres = chain(:/, Expr(:call, :*, :op, 2), 2)
    addres = chain(:+, Expr(:call, :-, :op, 2), 2)

    context("Close method") do
         @fact eval(logres).values --> op.values
         @fact eval(divres).values --> op.values
         @fact eval(addres).values --> op.values
    end
end
