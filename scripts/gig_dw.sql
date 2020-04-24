drop table if exists dw_fct_events cascade;

create table dw_fct_events as
select c.*, b.type_name , d.dayofweek , e.mbid,f."name", g.group_name,a.country, a.no_of_events
from fct_ukevents a, dim_event_type b, dim_time c, dim_dayofweek d, dim_event_artist e, dim_mbartist f, dim_artist_group g
where a.type_id = b.type_id 
and a.time_id = c.time_id 
and a.day_id = d.day_id 
and a.mbid = e.mbid 
and e.mbid = f.gid 
and e.group_id = g.group_id ;

drop table if exists dw_fct_events_start_time cascade;

create table dw_fct_events_start_time as 
select c.*, b.type_name , d.dayofweek, e.hour_of_day, a.no_of_events
from fct_ukevents_start_time a, dim_event_type b, dim_time c, dim_dayofweek d, dim_event_start_time e 
where a.type_id = b.type_id and a.time_id = c.time_id and a.day_id = d.day_id and a.start_time_id = e.start_time_id;

drop table if exists dw_fct_artist_popularity cascade;

create table dw_fct_artist_popularity as

select b.*,a.artist_mbid,c.artist, d.region, a.sumofstreams, a.tracks_in_top200, a.peak_position 
from fct_streamcount_popularity a
, dim_time b, dim_spotifyartist c, dim_location d
where a.artist_mbid = c.artist_mbid 
and a.region_id = d.region_id 
and a.time_id = b.time_id 
and c.artist = 'Lewis Capaldi'
and region = 'gb' and a.time_id  in (select distinct time_id from dw_fct_artist_popularity) 



select * from fct_ukevents_start_time fust 
