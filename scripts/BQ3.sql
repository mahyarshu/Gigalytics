--fct_event_artist_venue
SELECT 
	mb.mbid as artist_id,
	ve.venue_id,
	ve.city,
	count(*) count_event,
	sum(popularity) sum_popularity,
	avg(popularity) avg_popularity
into fct_event_artist_venue
FROM public."songkick_ukEvents_withName" eve --50,155
inner join public.dim_mbartist mb on eve.mbid  = mb.mbid --48,665
inner join public.dim_venues ve on eve."venueId"  = ve.venue_id  --46063
group by artist_id, mb.name, ve.venue_id , city;

--fct_event_venues
SELECT 
	ve.venue_id,
	ve.city,
	count(*) count_event,
	sum(popularity) sum_popularity,
	avg(popularity) avg_popularity
into fct_event_venues
FROM public."songkick_ukEvents_withName" eve --50,155
inner join public.dim_venues ve on eve."venueId"  = ve.venue_id  --46063
group by ve.venue_id , city;

--fct_event_cities
SELECT 
	ve.city,
	count(*) count_event,
	sum(popularity) sum_popularity,
	avg(popularity) avg_popularity
into fct_event_cities
FROM public."songkick_ukEvents_withName" eve --50,155
inner join public.dim_venues ve on eve."venueId"  = ve.venue_id  --46063
group by city;

update fct_event_cities
set city = 'Unknown' where city is null

--fct_artist_cities
SELECT 
	mb.mbid as artist_id,
	ve.city,
	count(*) count_event,
	sum(popularity) sum_popularity,
	avg(popularity) avg_popularity
into fct_artist_cities
FROM public."songkick_ukEvents_withName" eve --50,155
inner join public.dim_mbartist mb on eve.mbid  = mb.mbid --48,665
inner join public.dim_venues ve on eve."venueId"  = ve.venue_id  --46063
group by artist_id, mb.name, city;