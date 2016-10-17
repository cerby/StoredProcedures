declare @date1 datetime
declare @date2 datetime
set @date1 = '2013-11-19 15:26:40.000'
set @date2 = '2014-11-20 10:12:02.000'


declare @date3 nvarchar(200)

exec rssp_Statistic @date1, @date2, null, null, null, null, null, null, null, null, null, null, null, null, null, null



select *
from t_ErrorLog

select let_SenderTimeStamp
from t_Letter

--------------------

declare @SenderTimeFrom		datetime
declare @SenderTimeTo		datetime
declare @Where1				nvarchar(4000) 

set @SenderTimeFrom = '2013-10-08 09:38:00.000'
set @SenderTimeTo = '2013-10-08 04:50:00.000'
set @Where1 = ' '

exec rssp_DateStatistic @SenderTimeFrom,
							@SenderTimeTo,
							' t_Letter ',
							' let_SenderTimeStamp ',
							null,
							null,
							' let_SenderTimeStamp ',
							null,
							@Where1 out

select @Where1 as wherewhere 