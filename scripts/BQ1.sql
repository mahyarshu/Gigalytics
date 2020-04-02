--**************************************
-- Derive Artist Dimension Table
--**************************************
--create or replace view vw_unique_artist as
create table tbl_unique_artist_name as
select count(week_position), artist
from spotify_top_200_weekly stw 
group by artist -- 554 unique artist


create table tbl_unique_artist_mbid as 
select count(artist_mbid), artist_spotify_id , artist_mbid,  artist_name 
from spotify_track_details std 
where artist_mbid <> '' --although this can be changed to artist_spotify_id, we may not be able to use
						--the same when joining this star schema with the songkick schema
group by artist_spotify_id , artist_mbid,  artist_name 
--581 unique mbids (this may be due to the fact some tracks are collabos, 
--although only the name of the top artist appears in the chart 

--investigating using artist_spotify_id
create table tbl_unique_artist_spotify_id as
select count(artist_spotify_id),  artist_spotify_id, artist_mbid, artist_fychart_name, ROUND(AVG(track_popularity)) as artist_popularity
from spotify_track_details std 
where lower(artist_name) = lower(artist_fychart_name )
group by artist_spotify_id, artist_mbid, artist_fychart_name 
order by 1 desc
--554 unique artist_spotify_id (this is due to the fact that some tracks are collabos, 
--although only the name of the top artist appears in the chart


-- join the two dataset to get list of unique artists using mbid
create table dim_mbArtist as 
select b.artist_mbid, b.artist_spotify_id, a.artist
from tbl_unique_artist_name a 
left outer join tbl_unique_artist_mbid b
on lower(trim(a.artist)) = lower(trim(b.artist_name))
where b.artist_mbid is not null 
--405 unique artist with mbid from a total of 554 (149 without mbid)


-- join the two dataset to get list of unique artists usng spotify_id
create table dim_spotifyArtist as
select b.artist_spotify_id, b.artist_mbid, a.artist, b.artist_popularity
from tbl_unique_artist_name a 
left outer join tbl_unique_artist_spotify_id b
on lower(trim(a.artist)) = lower(trim(b.artist_fychart_name))
where b.artist_fychart_name is not null 
--405 unique artist with mbid from a total of 554 (149 without mbid)


--**************************************
-- Derive Location Dimension Table
--**************************************
create table dim_Location as
select distinct region  from spotify_top_200_weekly stw 


--**************************************
-- Derive Time Dimension Table
--**************************************
create table dim_Time as
SELECT distinct to_char(start_date, 'yyyymmiw') as time_id, 
to_char(start_date, 'yyyy') as year,
to_char(start_date, 'mm') as month,
to_char(start_date, 'iw') as week
FROM spotify_top_200_weekly
order by 1


--**************************************
-- Derive Track Dimension Table
--**************************************
create table dim_Tracks as
select distinct spotify_id, track_name, std.artist_spotify_id, std.artist_mbid, 
std.track_duration_ms, std.track_url, std.track_popularity
from spotify_top_200_weekly stw, spotify_track_details std 
where (stw.spotify_id = std.track_spotify_id and std.artist_fychart_name = std.artist_name)


--**********************************************
-- Derive streamcount_popularity fact Table
--**********************************************
create table fct_streamcount_popularity as
select a.region, c.time_id, b.artist_spotify_id , sum(d.streams) as sumofstreams, avg(b.artist_popularity) as avg_popularity
from dim_location a, 
	dim_spotifyartist b, 
	dim_time c, 
	spotify_top_200_weekly d 
where c.time_id = to_char(d.start_date, 'yyyy') || to_char(d.start_date, 'mm') || to_char(d.start_date, 'iw')
		 and d.region = a.region and d.artist = b.artist
		 and d.artist = b.artist 
group by a.region, c.time_id, b.artist_spotify_id
order by  a.region, c.time_id asc ,sum(d.streams) desc


