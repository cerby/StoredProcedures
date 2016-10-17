


use CloverleafRSD
go

create function rsfn_IntInputStatistic(@MSGStatus int)
returns varchar(400)

as
begin

set @MSGStatus = 4

return @MSGStatus
end
go