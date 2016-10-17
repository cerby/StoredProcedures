use CloverleafRSD
go

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