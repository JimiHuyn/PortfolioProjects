--Possible visuals for Tableau-- 

-- Best Ranking Game throughout the Year
Select Distinct Game, Rank, Month, Year, Hours_watched
From Twitch_game_data
Where Rank = '1' 
Order by Year ASC

-- Showing Twitch catergory with highest watch count 
Select top 20 Game, Month, Year, MAX(Hours_watched) as Watch_count
From Twitch_game_data
Where Year = '2021'
Group by Game, Month, Year 
order by Watch_count desc

-- Showing Twitch Catergory with highest stream count
Select top 20 Game, Month, Year, MAX(Hours_Streamed) as Stream_count
From Twitch_game_data
Where Year = '2021'
Group by Game, Month, Year 
order by Stream_count desc

-- Showing games with most streamers creating content for Twitch

Select top 20 Game, Month, Year, MAX(Streamers) as Content_Creator
From Twitch_game_data
Where Year = '2021'
Group by Game, Month, Year, Streamers
order by Streamers desc

-- Streamers count in 2016 to 2021 

Select Year, Month, SUM(Streamers) as Content_Creator
From Twitch_game_data
Where Year = '2016'
Group by Year, Month
order by Content_Creator asc	

-- Top Ranked category/game in 2021
Select Distinct Rank, Game, Month, Year
From Twitch_game_data
Where Rank = '1' AND Year = '2021' 

-- Finding Average hours watched for the year 2021 for JustChatting
Select Game, Year, AVG(Hours_watched) AS Average_Total_Watched_Yearly
From Twitch_game_data
Where Game = 'Just chatting' AND Year = '2021'
Group by Game, Year 

-- Finding Average hours watched for the year 2021 for League of Legends
Select Game, Year, AVG(CAST(Hours_watched as int)) AS Average_Total_Watched_Yearly
From Twitch_game_data
Where Game = 'League of Legends' AND Year = '2021'
Group by Game, Year 

-- Finding Average hours watched for the year 2021 for fortnite
Select Game, Year, AVG(CAST(Hours_watched as int)) AS Average_Total_Watched_Yearly
From Twitch_game_data
Where Game = 'fortnite' AND Year = '2021'
Group by Game, Year 

-- Looking at Global data VS Game Data on hours watched vs Total Twitch hours watched

Select top 200 gd.rank, gd.Game, gd.Month, gd.Year, gd.Hours_watched, (gld.Hours_watched) as Total_Twitch_Hours, str((gd.Hours_watched/gld.Hours_watched)*100,4,1) as WatchedPercentage
From Twitch_game_data gd
Join Twitch_global_data gld
	on gd.Month = gld.Month
	AND gd.Year = gld.year
Order by WatchedPercentage desc

-- Showing 2021 data on Twitch data VS Game Data on hours watched vs Total Twitch hours watched
Select top 200 gd.rank, gd.Game, gd.Month, gd.Year, gd.Hours_watched, (gld.Hours_watched) as Total_Twitch_Hours, str(100*gd.Hours_watched/gld.Hours_watched,4,1) as WatchedPercentage
From Twitch_game_data gd
Join Twitch_global_data gld
	on gd.Month = gld.Month
	AND gd.Year = gld.year
Where gd.Year = '2021'
Order by WatchedPercentage desc

-- Using CTE 

With TwitchvsGame (Rank, Game, Month, Year, Hours_Watched, Total_Twitch_Hours, peak_viewers, WatchedPercentage)
as
(
Select gd.rank, gd.Game, gd.Month, gd.Year, gd.Hours_watched, (gld.Hours_watched) as Total_Twitch_Hours, gld.Peak_viewers, str(100*gd.Hours_watched/gld.Hours_watched,4,1) as WatchedPercentage
From Twitch_game_data gd
Join Twitch_global_data gld
	on gd.Month = gld.Month
	AND gd.Year = gld.year
Where gd.Year = '2021'
--Order by WatchedPercentage desc
)
Select *, ROUND(peak_viewers*WatchedPercentage/100, 0) as Estimate_viewership
From TwitchvsGame

