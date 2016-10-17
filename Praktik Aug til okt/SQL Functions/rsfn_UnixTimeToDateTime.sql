--**v. 0.1 :2014-08-18 christopher.veggerskilde.buch@rsyd.dk
--** takes unixtime from varchar(32) and converts to datetime with timezone

use CloRSDDevl
go

create function rsfn_UnixTimeToDateTime(@timestamp varchar(40))
returns datetime

as
begin

declare @datetimeoffset varchar(40)
declare @ALDT			varchar(40)

set @datetimeoffset = DATEDIFF(s,GETDATE(),GETUTCDATE())
set @ALDT =@timestamp - @datetimeoffset

return (select DATEADD(s, @ALDT, CAST('1970-01-01 00:00:00' AS datetime)))

end
go

