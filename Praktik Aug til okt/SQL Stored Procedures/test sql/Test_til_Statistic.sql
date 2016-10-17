use CloverleafRSD
go

declare @date1 datetime
declare @date2 datetime
set @date1 = '2013-11-19 15:26:40.000'
set @date2 = '2014-11-20 10:12:02.000'



			exec rssp_Statistic null,	--letterstarttime
								null,	--letterendtime
								@date1,	--cloverleafstarttime
								@date2,	--cloverleafendtime
								null,	--lettertype
								1,		--messagestatus
								null,	--servername
								'router_site',	--site
								'router',	--process
								'fr_edifact',	--thread
								'579000182981',	--SenderEAN
								null,	--SenderSORID
								'550105Z;550102A;5501028;5501219;550105J;550145J;550105E;550145E',	--SenderSKS/SHAK
								null,	--receiverEAN
								null,	--receiverSORID
								null	--receiverSHAK


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