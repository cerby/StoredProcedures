


use CloverleafRSD
go

create function rsfn_DateInputStatistic(@TimeTimeStamp datetime)
returns varchar(400)

as
begin

set @TimeTimeStamp = GETDATE()

return @TimeTimeStamp
end
go