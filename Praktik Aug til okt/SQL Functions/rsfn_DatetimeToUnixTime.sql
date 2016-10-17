--**v. 0.1 :2014-08-18 christopher.veggerskilde.buch@rsyd.dk
--** takes datetime from varchar(32) and converts to unixtime with timezone 

use CloRSDDevl
go

create function rsfn_DatetimeToUnixTime(@enddate datetime)
returns varchar(40)

as
begin

declare @convert	varchar(40)
declare @timezone	float
declare @time		float
declare @temp		float

set @timezone = datediff(s, getdate(), GETUTCDATE())
set @time = datediff(s,'1970-01-01 00:00:00',@enddate)
--skal der lægges til eller trækkes fra?
set @temp = @time + @timezone
set @convert =cast(@temp as varchar(40))

return @convert
end
go
