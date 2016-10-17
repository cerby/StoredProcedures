if exists(select * 
          from sys.indexes 
		  where object_id = object_id('t_OrganisationUnit_LetterType_MessageDirection') and 
		        name like 'idx_t_OrganisationUnit_LetterType_MessageDirection_org_Active')
  drop index idx_t_OrganisationUnit_LetterType_MessageDirection_org_Active 
  on t_OrganisationUnit_LetterType_MessageDirection
go

update t_OrganisationUnit_LetterType_MessageDirection
set old_InternalTraffic = 1, old_ExternalTraffic = 1
where old_InternalTraffic is null
and old_ExternalTraffic is null

alter table t_OrganisationUnit_LetterType_MessageDirection
alter column old_Active bit not null

alter table t_OrganisationUnit_LetterType_MessageDirection
alter column old_InternalTraffic bit not null

alter table t_OrganisationUnit_LetterType_MessageDirection
alter column old_ExternalTraffic bit not null

create index idx_t_OrganisationUnit_LetterType_MessageDirection_org_Active 
on t_OrganisationUnit_LetterType_MessageDirection(old_Active)
go