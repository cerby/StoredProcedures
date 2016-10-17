if object_id('ParentProc','P') is not null
	drop procedure ParentProc;
go
create procedure ParentProc 
as 
begin
	set nocount on;
 
	exec ChildProc;
	--if OBJECT_ID('tempdb..##tempTable') is not null
	select * from ##tempTable;
end
go
 
if object_id('ChildProc','P') is not null
	drop procedure ChildProc;
go
create procedure ChildProc
as
begin
	set nocount on;
	if OBJECT_ID('tempdb..##tempTable') is not null
		drop table ##tempTable;
	create table ##tempTable (firstName  nvarchar(50));
	insert into ##tempTable (firstName) 
		select Name
		from t_cdArtist;
end	
go
 
--execute the parent proc
exec ParentProc;