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

/*
drop table if exists dw_fct_events_start_time cascade;
create table dw_fct_events_start_time as 
select c.*, b.type_name , d.dayofweek, e.hour_of_day, a.no_of_events
from fct_ukevents_start_time a, dim_event_type b, dim_time c, dim_dayofweek d, dim_event_start_time e 
where a.type_id = b.type_id and a.time_id = c.time_id and a.day_id = d.day_id and a.start_time_id = e.start_time_id;
*/

--BQ1
drop table if exists dw_fct_artist_popularity cascade;
create table dw_fct_artist_popularity as
select b.*,a.artist_mbid,c.artist, d.region, a.sumofstreams, a.tracks_in_top200, a.peak_position 
from fct_streamcount_popularity a
, dim_time b, dim_spotifyartist c, dim_location d
where a.artist_mbid = c.artist_mbid 
and a.region_id = d.region_id 
and a.time_id = b.time_id ;

/*
and c.artist = 'Lewis Capaldi'
and region = 'gb' and a.time_id  in (select distinct time_id from dw_fct_artist_popularity);
*/


--BQ3
drop table if exists dw_fct_events_venues cascade;
create table dw_fct_events_venues as 
select b.*, c."name" venue_name, d."name" city , a.no_of_event, a.avg_popularity
from fct_event_venues a, dim_time b, dim_venues c, dim_cities d, dim_event_artist e
where a.mbid = e.mbid 
and a.time_id = b.time_id 
and a.venue_id  = c.venue_id 
and c.city_id = d.city_id ;



--BQ4
drop table if exists dw_fct_ukevent_start_time cascade;
create table dw_fct_ukevent_start_time as
select c.time_id, b.hour_of_day, e.type_name, sum(a.no_of_events) no_of_event
from fct_ukevents_start_time a, dim_event_start_time b, dim_time c, dim_event_artist d, dim_event_type e, dim_dayofweek f
where b.start_time_id = a.start_time_id 
and c.time_id = a.time_id 
and d.mbid = a.mbid 
and e.type_id = a.type_id
and f.day_id =a.day_id
group by c.time_id, b.hour_of_day, e.type_name;

