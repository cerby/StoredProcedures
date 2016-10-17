declare @start int
declare @end int
declare @string nvarchar(50)
declare @streng nvarchar(50)
declare @tempo table
(
numre nvarchar(20)
)

set @start = 1


set @string = '5790000212255;5790000214983;5790000214785;'
set @end = charindex(';', @string, @start)
set @streng = substring(@string,@start,@end - @start)
insert into @tempo values(@streng)
select charindex(';', @string) as charter

set @start = @end+1

set @end =charindex(';', @string, @start)

select @end as ending

set @streng = substring(@string,@start, @end - @start)
insert into @tempo values(@streng)

select *
from @tempo join t_OrganisationUnit on numre = org_LocationEAN
where numre = org_LocationEAN