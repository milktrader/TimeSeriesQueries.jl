Using the @select macro
=======================

In addition to the common methods of splitting TimeArrays based on value and time predicates, the ``@select`` macro is provided. This alternative
method of querying TimeArrays feels natural to users of SQL-like databases. The construction of a query must follow an order that starts with a call to
a TimeArray, is followed by one or more column-definitions and some filter on them, and is completed with a time-based filter. The definition of a 
TimeArray object is required along with either a column-defined query or a time-based query. Including both column-defined queries and time-based 
queries together is also supported.

The following table may help keep track of how queries should be constructed. Examples are taken from the MarketData package of 
time series objects.

+----------+---------------------------------------+----------------------------------+
| Command  | Description                           | Optionality                      |
+==========+=======================================+==================================+
| @select  | begin query                           | required                         |
+----------+---------------------------------------+----------------------------------+
| AAPL     | TimeArray object to be queried        | required                         |
+----------+---------------------------------------+----------------------------------+
| where    | begin definition of columns           | required if ``when`` not used    |
+----------+---------------------------------------+----------------------------------+
| Open     | the first column to be queried        | required if ``where`` used       |
+----------+---------------------------------------+----------------------------------+
| .>       | operator on Open column               | not required                     |
+----------+---------------------------------------+----------------------------------+
| 100      | comparison value for operator         | required if operator defined     |
+----------+---------------------------------------+----------------------------------+
| when     | begin definition of time-based query  | required if ``where`` not used   |
+----------+---------------------------------------+----------------------------------+
| dayname  | Base.Dates Datetime method to be used | required if ``where`` used       |
+----------+---------------------------------------+----------------------------------+
| 2000     | value to filter time-based query      | required if Datetime method used |  
+----------+---------------------------------------+----------------------------------+

Here are some basic examples in REPL::

    julia> using TimeSeries, TimeSeriesQueries, MarketData

    julia> op_gen(AAPL) #defines column from the AAPL TimeArray as methods

    julia> AAPL
    8336x12 TimeSeries.TimeArray{Float64,2,Date,Array{Float64,2}} 1980-12-12 to 2013-12-31

                 Open      High      Low       Close     Volume          Ex-Dividend  Split Ratio  Adj. Open  Adj. High  Adj. Low  Adj. Close  Adj. Volume     
                 1980-12-12 | 28.75     28.88     28.75     28.75     2093900         0.0          1            3.3766     3.3919     3.3766    3.3766      16751200        
                 1980-12-15 | 27.38     27.38     27.25     27.25     785200          0.0          1            3.2157     3.2157     3.2004    3.2004      6281600         
                 1980-12-16 | 25.38     25.38     25.25     25.25     472000          0.0          1            2.9808     2.9808     2.9655    2.9655      3776000         
                 1980-12-17 | 25.88     26.0      25.88     25.88     385900          0.0          1            3.0395     3.0536     3.0395    3.0395      3087200         
                 ⋮
                 2013-12-26 | 568.1     569.5     563.38    563.9     7286000         0.0          1            564.7392   566.1309   560.0471  560.564     7286000         
                 2013-12-27 | 563.82    564.41    559.5     560.09    8067300         0.0          1            560.4845   561.071    556.1901  556.7766    8067300         
                 2013-12-30 | 557.46    560.09    552.32    554.52    9058200         0.0          1            554.1621   556.7766   549.0525  551.2395    9058200         
                 2013-12-31 | 554.17    561.28    554.0     561.02    7967300         0.0          1            550.8916   557.9595   550.7226  557.7011    7967300         
    julia> @select AAPL where Open
    8336x1 TimeSeries.TimeArray{Float64,1,Date,Array{Float64,1}} 1980-12-12 to 2013-12-31

                 Open      
                 1980-12-12 | 28.75     
                 1980-12-15 | 27.38     
                 1980-12-16 | 25.38     
                 1980-12-17 | 25.88     
                 ⋮
                 2013-12-26 | 568.1     
                 2013-12-27 | 563.82    
                 2013-12-30 | 557.46    
                 2013-12-31 | 554.17 

    julia> @select AAPL where Open when year 1999
    252x1 TimeSeries.TimeArray{Float64,1,Date,Array{Float64,1}} 1999-01-04 to 1999-12-31

                 Open      
                 1999-01-04 | 42.12     
                 1999-01-05 | 41.94     
                 1999-01-06 | 44.12     
                 1999-01-07 | 42.25     
                 ⋮
                 1999-12-28 | 99.12     
                 1999-12-29 | 96.81     
                 1999-12-30 | 102.19    
                 1999-12-31 | 100.94    

    julia> @select AAPL where Open .> 100 when year 1999
    252x1 TimeSeries.TimeArray{Bool,1,Date,BitArray{1}} 1999-01-04 to 1999-12-31

                 Open.>100  
                 1999-01-04 | false      
                 1999-01-05 | false      
                 1999-01-06 | false      
                 1999-01-07 | false      
                 ⋮
                 1999-12-28 | false      
                 1999-12-29 | false      
                 1999-12-30 | true       
                 1999-12-31 | true       

    julia> sum(ans.values)
    15
