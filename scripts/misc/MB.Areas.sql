select
	a3.id ,
	a3."name",
	a2.id ,
	a2."name",
	a."name"
from
	musicbrainz.l_area_area aa
	inner join musicbrainz.l_area_area aa2 on aa.entity1 = aa2.entity0
	inner join musicbrainz.l_area_area aa3 on aa2.entity1 = aa3.entity0
	inner join area  a  on aa2.entity0  = a.id 
	inner join area  a2  on aa2.entity1 = a2.id
	inner join area  a3  on aa3.entity1 = a3.id
where
	(aa.entity0 = 221
	or aa.entity0 = 434
	or aa.entity0 = 432
	or aa.entity0 = 433
	or aa.entity0 = 433) 
and a3.name like '%heffiel%'
order by a2.id
