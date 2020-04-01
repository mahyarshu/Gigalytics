select * from "dim.artists" da where da.gid in (
select distinct gid  from "dim.artists");

select * from "dim.events";

select * from "dim.artists" da 
where lower(da."name") like '%minaj%';

select * from "dim.artists" da 
where lower(da."name") like '%bradley%cooper%'

select * from "dim.artists" da 
where lower(da."name") like '%post%malone%'


--uisng the levenshtein similarity function 
--https://stackoverflow.com/questions/48425685/pyspark-levenshtein-join-error 
SELECT
	*,
    LEVENSHTEIN(da."name" , 'Rag n Bone Man') as a_name
FROM "dim.artists" da
ORDER BY a_name ASC
LIMIT 5


CREATE EXTENSION pg_trgm;
SELECT
	*
from "dim.artists" da 
WHERE SIMILARITY(da."name" ,'Rag n Bone Man	') > 0.5 ;

select count(track_spotifyID), artist_spotifyID from spotify_track_details std 
where artist_spotifyid in (select distinct artist_spotifyid from spotify_track_details where artist_mbid = '')
group by artist_spotifyid
order by artist_name 

--
select count(track_spotifyID), artist_spotifyID, artist_name
from spotify_track_details std 
where artist_mbid =''
group by artist_spotifyid, artist_name
order by 1 desc

select * from spotify_track_details std  where artist_spotifyid = '5VadK1havLhK1OpKYsXv9y'

select count(mbid), artist_lastfm from kaggle_artists ka
where artist_lastfm = artist_mb 
group by artist_lastfm 
order by 1 desc

select * from kaggle_artists ka where artist_lastfm ='Karma'


select count(id), sort_name from "dim.artists" da2 
--where artist_lastfm = artist_mb 
group by sort_name 
order by 1 desc

select * from "dim.artists" da 
where sort_name ='Indigo'

select count(1) from (
select distinct * from "dim.artists") da
 

--*****************************************************************
--*****************************************************************
--		Investigate missing mbid for top artist                 --
--*****************************************************************
--*****************************************************************

-- create a view to hold weekly top 10 tracks in the UK
create or replace view spotify_top_10_weekly as
select * from spotify_top_200_weekly stw 
where CAST("Position" AS INTEGER) >0  and CAST("Position" AS INTEGER) <= 10
and  region = 'gb'

-- Unique artist within the weekly top 10 tracks
create or replace view vw_unique_uk_artist as 
select count('position'), "Artist"  from spotify_top_10_weekly stw 
where stw.region = 'gb'
group by "Artist" 

-- create a view to hold weekly top 10 tracks globally
create view vw_unique_global_artist as 
select count('position'), "Artist" from spotify_top_200_weekly stw 
where stw.region = 'global'
group by "Artist"

-- Create a view to hold unique artist mbids extracted using the mbspotify library
create view vw_unique_artist_mbid as 
select count(artist_mbid), artist_spotifyid , artist_mbid,  artist_name 
			from spotify_track_details std 
			where artist_mbid <> ''
			group by artist_spotifyid , artist_mbid,  artist_name 
			
---- Create a view to hold unique artist mbids extracted using the kaggle dataset
create view vw_kaggle_unique_artist_mbid as
select count(mbid), mbid,  artist_mb
			from kaggle_artists ka
			--where lower(artist_mb) like '%a%'
			group by mbid,  artist_mb
			order by 3 desc
			
-- 
select count(1) from spotify_top_10_weekly

select count(1) from public.vw_unique_uk_artist 

select count(1) from public.vw_unique_global_artist 

select count(1) from public.vw_unique_artist_mbid 

select * from vw_unique_artist_mbid order by 4;

select * from vw_unique_artist_mbid order by 4;


--tracks with artist whose mbid is valid (uk only)
select count(1) from vw_unique_uk_artist a 
left outer join vw_unique_artist_mbid b
on a."Artist" = b.artist_name
where b.artist_mbid is not null
--order by 2

-- tracks with artist whose mbid is valid (global)
select * from vw_unique_global_artist a 
left outer join vw_unique_artist_mbid b
on a."Artist" = b.artist_name
where b.artist_mbid is not null
order by 2

select * from vw_unique_uk_artist a 
left outer join kaggle_artists b
on a."Artist" = b.artist_lastfm 
order by 2 desc
--where b.artist_mb is not null

