select * from public."dim.areas" where name = 'London'
delete from  public."dim.areas"

(select
		a3.id,
		a3."name"
	from
		public."dim.area_area" aa
	inner join public."dim.area_area" aa2 on
		aa.related_area_id = aa2.main_area_id
	inner join public."dim.area_area" aa3 on
		aa2.related_area_id = aa3.main_area_id
	inner join public."dim.areas" a on
		aa2.main_area_id = a.id
	inner join public."dim.areas" a2 on
		aa2.related_area_id = a2.id
	inner join public."dim.areas" a3 on
		aa3.related_area_id = a3.id
	where
		aa.main_area_id = 221
		or aa.main_area_id = 434
		or aa.main_area_id = 432
		or aa.main_area_id = 433
		or aa.main_area_id = 433 
union 
select
		a2.id,
		a2."name"
	from
		public."dim.area_area" aa
	inner join public."dim.area_area" aa2 on
		aa.related_area_id = aa2.main_area_id
	inner join public."dim.areas" a on
		aa2.main_area_id = a.id
	inner join public."dim.areas" a2 on
		aa2.related_area_id = a2.id
	where
		aa.main_area_id = 221
		or aa.main_area_id = 434
		or aa.main_area_id = 432
		or aa.main_area_id = 433
		or aa.main_area_id = 433 
union 
select
		a.id,
		a."name"
	from
		public."dim.area_area" aa
	inner join public."dim.areas" a on
		aa.main_area_id = a.id
	where
		aa.main_area_id = 221
		or aa.main_area_id = 434
		or aa.main_area_id = 432
		or aa.main_area_id = 433
		or aa.main_area_id = 433) 