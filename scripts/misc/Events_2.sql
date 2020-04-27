select
	e.id,
	e.gid,
	e."time",
	e."type",
	e.cancelled,
	e.ended,
	e.begin_date_id,
	e.end_date_id,
	duration--,
	--d.date_actual,
	--en.date_actual,
	--er.id,
	--er."name"
--	count(*)
	from public."dim.events" e
--inner join public."dim.dates" d on
--	e.begin_date_id = d.date_dim_id
--inner join public."dim.dates" en on
--	e.end_date_id = en.date_dim_id
inner join public."dim.area_events" ae on
	e.id = ae.event_id
--left join public."dim.area_area" aa on
--	ae.area_id = aa.related_area_id
--left join public."dim.areas" er on
--	aa.related_area_id = er.id
where
	--d.date_dim_id >= 20190301
	--and en.date_dim_id <= 20200229
	--and 
	ae.area_id  = 1178
order by begin_date_id 
--	and ae.area_id in (
--	select
--		aa3.related_area_id
--	from
--		public."dim.area_area" aa
--	inner join public."dim.area_area" aa2 on
--		aa.related_area_id = aa2.main_area_id
--	inner join public."dim.area_area" aa3 on
--		aa2.related_area_id = aa3.main_area_id
--	where
--		aa.main_area_id = 221
--		or aa.main_area_id = 434
--		or aa.main_area_id = 432
--		or aa.main_area_id = 433
--		or aa.main_area_id = 433 
--union 
--select
--		aa2.related_area_id
--	from
--		public."dim.area_area" aa
--	inner join public."dim.area_area" aa2 on
--		aa.related_area_id = aa2.main_area_id
--	where
--		aa.main_area_id = 221
--		or aa.main_area_id = 434
--		or aa.main_area_id = 432
--		or aa.main_area_id = 433
--		or aa.main_area_id = 433 
--union 
--select
--		aa.main_area_id
--	from
--		public."dim.area_area" aa
--	where
--		aa.main_area_id = 221
--		or aa.main_area_id = 434
--		or aa.main_area_id = 432
--		or aa.main_area_id = 433
--		or aa.main_area_id = 433 )
	

