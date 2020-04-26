-- Drop table

-- DROP TABLE public.musicbrainz_artists;

CREATE TABLE public.musicbrainz_artists (
	gid text NULL,
	"name" text NULL,
	"type" float8 NULL,
	gender float8 NULL,
	is_active bool NULL
);

-- Drop table

-- DROP TABLE public.dim_mbartist;

CREATE TABLE public.dim_mbartist (
	mbid text NULL,
	"name" text NULL,
	"type" float8 NULL,
	gender float8 NULL
);

-- Drop table

-- DROP TABLE public.dim_venues;

CREATE TABLE public.dim_venues (
	venue_id float8 null primary key,
	"name" text NULL,
	city text NULL,
	capacity float8 NULL
);

update dim_venues
set city = 'Unknown' where city is null;

create table public.dim_cities(
	city_id bigint GENERATED ALWAYS AS identity primary key,
	"name" text NULL
);

insert into public.dim_cities (name)
select distinct city from songkick_uk_events eve 
inner join public.dim_venues ve on eve.venue_id  = ve.venue_id 

-- dw_fct_city_venue_events
SELECT 
	c.city_id,
	ve.venue_id ,
	t.time_id,
	count(*) count_event,
	avg(popularity) avg_popularity
into dw_fct_city_venue_events
FROM public.songkick_uk_events eve --50,155
inner join public.dim_venues ve on eve.venue_id  = ve.venue_id  --46063
inner join public.dim_cities c on ve.city = c."name" 
inner join public.dim_time t on eve.start_date = t.chart_date 
group by c.city_id, ve.venue_id , t.time_id;



ALTER TABLE public.dw_fct_city_venue_events ADD CONSTRAINT dw_fct_city_venue_events_fk FOREIGN KEY (time_id) REFERENCES dim_time(time_id);
ALTER TABLE public.dw_fct_city_venue_events ADD CONSTRAINT dw_fct_city_venue_events_fk_1 FOREIGN KEY (city_id) REFERENCES dim_cities(city_id);
ALTER TABLE public.dw_fct_city_venue_events ADD CONSTRAINT dw_fct_city_venue_events_fk_2 FOREIGN KEY (venue_id) REFERENCES dim_venues(venue_id);