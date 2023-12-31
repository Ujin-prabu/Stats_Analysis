/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Match number]
      ,[Year]
      ,[Played For]
      ,[Opponent]
      ,[Runs scored]
      ,[balls faced]
      ,[Strikerate]
      ,[out/notout]
      ,[4s]
      ,[6s]
      ,[overs bowled]
      ,[Maidens]
      ,[Runs conceded]
      ,[wickets taken]
      ,[Economy]
      ,[catches]
      ,[st]
      ,[Runout]
  FROM [Personal_Sc].[dbo].[performance]

  Select *
FROM [Personal_Sc].[dbo].[performance]

  ---- Total Runs Scored 
  select Sum([Runs scored]) as Total_runs,Year
  From [Personal_Sc].[dbo].[performance]
  where [Runs scored] is not null
   group by Year
   order by Total_runs DESC
 

 ----- Total Wickets Taken 

 select Sum([wickets taken]) as Total_wickets,Year
  From [Personal_Sc].[dbo].[performance]
  where [wickets taken] is not null
   group by Year
   order by Total_wickets DESC

  ---- Total catches , stumping , runouts 
   select Sum([catches]) as Total_catches, Sum(st) as Total_stumping, Sum(Runout) As total_runout,Year
  From [Personal_Sc].[dbo].[performance]
  where catches is not null
  group by Year
  

  ----Total Not outs 
  select count([out/notout]) as Total_notout, Year
  From [Personal_Sc].[dbo].[performance]
  where [out/notout] = 'Not out'
  group by [out/notout],Year

  -----Runs scored For various teams 
  select Sum([Runs scored]) as Total_runs,[Played For]
  From [Personal_Sc].[dbo].[performance]
  where [Played For] is not null
  group by [Played For]
  order by Total_runs DESC

  ---- Total overs bowled and wickets taken 
   select Sum([overs bowled]) as Total_overs, SUM ([wickets taken]) as total_wickets, [Played For],Year
  From [Personal_Sc].[dbo].[performance]
  where [Played For] is not null
  group by [Played For],Year
  order by Year,
          total_wickets Desc

  ---- Total overs bowled and wickets taken against opponents
  select Sum([overs bowled]) as Total_overs, SUM ([wickets taken]) as total_wickets, [Opponent],Year
  From [Personal_Sc].[dbo].[performance]
  where [Played For] is not null
  group by [Opponent],Year
  order by Year,
           total_wickets DESC

  ---- 4's and 6's 
  select sum([4s]) as total_4s, Sum([6s]) as total_6s,[Played For],Year
   From [Personal_Sc].[dbo].[performance]
   where [Played For] is not null
   group by [Played For],Year
   order by Year,
            total_4s Desc

     ---- 4's and 6's  against opponents
select sum([4s]) as total_4s, Sum([6s]) as total_6s,[Opponent],Year
   From [Personal_Sc].[dbo].[performance]
   where [Opponent] is not null
   group by [Opponent],Year
   order by Year,
            total_4s Desc

--- overall Strike Rate 
select ROUND(Sum([Runs scored])/Sum([balls faced]),2)*100 as overall_strike_rate,Year
From [Personal_Sc].[dbo].[performance]
Where year is not null
Group by Year

----overall Avg
select ROUND(Sum([Runs scored])/Sum(case when [out/notout] = 'out' Then 1 else 0 end),2) as Avg_runs,Year
From [Personal_Sc].[dbo].[performance]
Where year is not null
Group by Year

--- Total golden ducks
Select sum (case when [balls faced] = 1 and [Runs scored]= 0 Then 1 else 0 end) as Golden_ducks
From [Personal_Sc].[dbo].[performance]

---- Toatal ducks 
Select sum (case when [Runs scored]= 0 Then 1 else 0 end) as Golden_ducks
From [Personal_Sc].[dbo].[performance]

-----total 50's 
select sum(case when [Runs scored] > = 50 Then 1 else 0 end) as Total_50s
From [Personal_Sc].[dbo].[performance]

---overall Economy

select ROUND(sum([Runs conceded])/(Sum(Economy)),2) as overall_economy, Year
From [Personal_Sc].[dbo].[performance]
where year is not null
group by Year

----30+ scores 
select sum(case when [Runs scored] > = 30 and [Runs scored] <= 50 Then 1 else 0 end) as Total_30s
From [Personal_Sc].[dbo].[performance]


---- Running Total of runs
Select [Match number],Year,[Runs scored],SUM([Runs scored]) over (order by [Match number]) as Running_total
From [Personal_Sc].[dbo].[performance]
where [Runs scored] is not null
order by [Match number] 

---- Running Total of wickets
Select [Match number],Year,[wickets taken],SUM([wickets taken]) over (order by [Match number]) as Running_total
From [Personal_Sc].[dbo].[performance]
where [wickets taken] is not null
order by [Match number] 

---- Top 5 Scores 
SELECT
   Top 5 [Match number],
   [Played For],
   Opponent,
   [4s],
   [6s],
    [Runs scored],
    DENSE_RANK() OVER (ORDER BY [Runs scored] DESC) AS Ranking
FROM
    [Personal_Sc].[dbo].[performance]
ORDER BY
    [Runs scored] DESC;

---- Top 5 best bowling 

SELECT
   Top 5 [Match number],
   [Played For],
   Opponent,
  [overs bowled],
      [Maidens],
      [Runs conceded],
    [wickets taken],
    DENSE_RANK() OVER (ORDER BY [wickets taken] DESC) AS Ranking
FROM
    [Personal_Sc].[dbo].[performance]
ORDER BY
    [wickets taken] DESC;