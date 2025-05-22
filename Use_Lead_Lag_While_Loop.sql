DECLARE @RowsUpdated INT;

SET @RowsUpdated = 1; 

WHILE @RowsUpdated > 0
BEGIN
WITH TimeIntervals AS (
    SELECT
        
        rai_code,
        timestamp_it AS StartDateTime,
        DATEADD(SECOND, duration, timestamp_it) AS EndDateTime
		,load_type,id,isrc,title,duration
		 
    FROM [dbo].[final_cuesheet_stage]
     where  isoverlap is null
	 --and id between 4415 and 4430
)
--update ad set ad.actualduration=m.actualDuration from (
, t2 as (

select rai_code,StartDateTime,EndDateTime,NextSongStartDateTime,DATEDIFF(second,StartDateTime,NextSongStartDateTime) actualDuration,duration,Nextduration,
load_type,nextType, case when load_type='M' then 1 when load_type='F' and nexttype='M' then 1 else 0 end mol,
case when 
(case when load_type='M' then 1 when load_type='F' and nexttype='M' then 1 else 0 end) =1 and (isrc=nextisrc or replace(replace(title,'-',''),'.','')= replace(replace(nexttitle,'-',''),'.','')  or DIFFERENCE(title, nexttitle) * 25 = 100) then 1 else 0 
end mol2

,id,NextId,NextId2,NextId3
,isrc,NextISRC,NextISRC2,NextISRC3
,title,NextTitle,NextTitle2,NextTitle3 
,nexttype2,nexttype3
,Nextduration2,Nextduration3
FROM (
    SELECT
    rai_code,
    StartDateTime,
    EndDateTime,
    load_type,
    id,
    isrc,
    title,
    duration,
    LEAD(StartDateTime, 1) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextSongStartDateTime,
    LEAD(load_type, 1) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS nextType,
    LEAD(id, 1) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextId,
    LEAD(isrc, 1) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextISRC,
    LEAD(title, 1) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextTitle,
    LEAD(duration, 1) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS Nextduration,
    LEAD(StartDateTime, 2) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextSongStartDateTime2,
    LEAD(load_type, 2) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS nextType2,
    LEAD(id, 2) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextId2,
    LEAD(isrc, 2) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextISRC2,
    LEAD(title, 2) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextTitle2,
    LEAD(duration, 2) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS Nextduration2,
    LEAD(StartDateTime, 3) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextSongStartDateTime3,
    LEAD(load_type, 3) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS nextType3,
    LEAD(id, 3) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextId3,
    LEAD(isrc, 3) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextISRC3,
    LEAD(title, 3) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS NextTitle3,
    LEAD(duration, 3) OVER (PARTITION BY rai_code ORDER BY StartDateTime) AS Nextduration3
FROM TimeIntervals

) t1 
where EndDateTime >NextSongStartDateTime  )



--select  * from t2

update ad set isoverlap='FP1' 

from (
 select mol,mol2,duration,Nextduration,Nextduration2,id,NextId,NextId2,load_type,nextType,nextType2, actualDuration,
case 
when load_type = 'F' and nextType='M' and nextType2= 'M' and (NextTitle=NextTitle2 or NextISRC=NextISRC2)  then id 
when duration<Nextduration and  load_type='F' then id
when duration>Nextduration and  nextType='M' then id
when duration=nextduration and load_type='F' then id 

else nextid   end select_id,rai_code
from t2 where mol2=1
) m

inner join dbo.final_cuesheet_stage ad on m.select_id=ad.id and m.rai_code=ad.rai_code

 SET @RowsUpdated = @@ROWCOUNT; -- Get the number of updated rows

END