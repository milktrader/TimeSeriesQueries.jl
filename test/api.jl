using MarketData
FactCheck.setstyle(:compact)
FactCheck.onlystats(true)

facts("macro tests") do

    context("select macro tests") do
        @fact 1 --> 2
    end

    context("let macro tests") do
        @fact 1 --> 2
    end

    context("where macro tests") do
        @fact 1 --> 2
    end

    context("when macro tests") do
        @fact 1 --> 2
    end

    context("collect macro tests") do
        @fact 1 --> 2
    end
end
