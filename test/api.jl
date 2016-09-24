using MarketData
FactCheck.setstyle(:compact)
FactCheck.onlystats(true)

facts("macro tests") do

    case1  = @select ohlc where Open
    case2  = @select ohlc when monthname "October"
    case3  = @select ohlc when year 2000
    case4  = @select ohlc where Low when monthname "January"
    case5  = @select ohlc where High when year 2001
    case6  = @select ohlc where Close .> 100
    case7  = @select ohlc where Open .> Close
    case8  = @select ohlc where Open .> 100 when dayname "Friday"
    case9  = @select ohlc where Close .> Low when dayname "Monday"
    case10 = @select ohlc where High .> 100 when month 2
    case11 = @select ohlc where Open .> Low when month 12

    context("@select ohlc where Open") do
        @fact length(case1)  --> 500
        @fact case1.colnames --> ["Open"]
    end

    context("@select ohlc when monthname October") do
        @fact length(case2)          --> 45
        @fact length(case2.colnames) --> 4
        @fact case2.timestamp[1]     --> Date(2000,10,2)
        @fact last(case2.timestamp)  --> Date(2001,10,31)
    end

    context("@select ohlc when year 2000") do
        @fact length(case3)          --> 252
        @fact length(case3.colnames) --> 4
        @fact case3.timestamp[1]     --> Date(2000,1,3)
        @fact last(case3.timestamp)  --> Date(2000,12,29)
    end

    context("@select ohlc where Low when monthname January") do
        @fact length(case4)         --> 41
        @fact case4.colnames        --> ["Low"]
        @fact case4.timestamp[1]    --> Date(2000,1,3)
        @fact last(case4.timestamp) --> Date(2001,1,31)
    end

    context("@select ohlc where High when year 2001") do 
        @fact length(case5)         --> 248
        @fact case5.colnames        --> ["High"]
        @fact case5.timestamp[1]    --> Date(2001,1,2)
        @fact last(case5.timestamp) --> Date(2001,12,31)
    end

    context("@select ohlc where Close .> 100") do
        @fact length(case6)         --> 500
        @fact case6.colnames        --> ["Close.>100"]
        @fact case6.timestamp[1]    --> Date(2000,1,3)
        @fact last(case6.timestamp) --> Date(2001,12,31)
        @fact sum(case6.values)     --> 89
    end

    context("@select ohlc where Open .> Close") do
        @fact length(case7)         --> 500
        @fact case7.colnames        --> ["Open.>Close"]
        @fact case7.timestamp[1]    --> Date(2000,1,3)
        @fact last(case7.timestamp) --> Date(2001,12,31)
        @fact sum(case7.values)     --> 252
    end
    
    context("@select ohlc where Open .> 100 when dayname Friday") do
        @fact length(case8)         --> 101
        @fact case8.colnames        --> ["Open.>100"]
        @fact case8.timestamp[1]    --> Date(2000,1,7)
        @fact last(case8.timestamp) --> Date(2001,12,28)
        @fact sum(case8.values)     --> 16
    end
    
    context("@select ohlc where Close .> Low when dayname Monday") do
        @fact length(case9)         --> 95
        @fact case9.colnames        --> ["Close.>Low"]
        @fact case9.timestamp[1]    --> Date(2000,1,3)
        @fact last(case9.timestamp) --> Date(2001,12,31)
        @fact sum(case9.values)     --> 95
    end

    context("@select ohlc where High .> 100 when month 2") do
        @fact length(case10)         --> 39
        @fact case10.colnames        --> ["High.>100"]
        @fact case10.timestamp[1]    --> Date(2000,2,1)
        @fact last(case10.timestamp) --> Date(2001,2,28)
        @fact sum(case10.values)     --> 20
    end

    context("@select ohlc where Open .> Low when month 12") do
        @fact length(case11)         --> 40 
        @fact case11.colnames        --> ["Open.>Low"]
        @fact case11.timestamp[1]    --> Date(2000,12,1)
        @fact last(case11.timestamp) --> Date(2001,12,31)
        @fact sum(case11.values)     --> 37
    end
end
