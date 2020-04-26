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
	venue_id float8 NULL,
	"name" text NULL,
	city text NULL,
	capacity float8 NULL
);

-- dw_fct_city_venue_events
SELECT 
	ve.city,
	ve."name",
	t."year" ,
	t."month" ,
	count(*) count_event,
	avg(popularity) avg_popularity
into dw_fct_city_venue_events
FROM public.songkick_uk_events eve --50,155
inner join public.dim_venues ve on eve.venue_id  = ve.venue_id  --46063
inner join public.dim_time t on eve.start_date = t.chart_date 
group by city, ve."name", t."year" , t."month" ;