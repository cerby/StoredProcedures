USE CloverleafRSD
GO

Create Procedure rssp_InsertRoute
				
				@SORID					varchar(50), 
				@LocationEAN			nvarchar(50),
				@LocationSKS			nvarchar(100),
				@LetterType				varchar(400), --NOT --NULL,
				@SystemID				varchar(200), --NULL if not NULL must be in t_system,
				@ReceiveFromLocation	nvarchar(400), --NULL,
				@DeliverToLocation		nvarchar(400), --NOT --NULL,
				@IsInbound				bit, --NOT --NULL,
				@Active					bit, --NOT NULL,
				@Remarks				text, --NULL,
				@InternalTraffic		bit, --NOT NULL,
				@ExternalTraffic		bit --NOT NULL,

as
begin
  declare @ErrorMessage   nvarchar(4000)
  declare @ErrorNumber    int
  declare @ErrorSeverity  int
  declare @ErrorState     int
  declare @ErrorLine      int
  declare @ErrorProcedure nvarchar(200) 

  declare @ErrCode				int
  declare @ErrMsg				nvarchar(100)
  declare @SystemIDID			int
  declare @LetterTypeID			int
  declare @OrganisationUnitID	int
  declare @UpdateTS				datetime --MUST BE A GETDATE()

  set @ErrCode = -1

  begin try

  set @ErrCode = -2
  set @UpdateTS = GETDATE()
  
  if(@Active is null)
   begin
    set @ErrCode = -3
    set @ErrMsg = 'Active can not be null, must be 1 or 0'
    set @ErrCode = 4
    raiserror(@ErrMsg,16,1)
   end --if
   
  set @ErrCode = -5

  if(@InternalTraffic is null)
   begin
    set @ErrCode =-6
	set @ErrMsg = 'InternalTraffic can not be null, must be 1 or 0'
	set @ErrCode = 7
	raiserror(@ErrMsg,16,1)
   end --if

   set @ErrCode = -8

   if(@ExternalTraffic is null)
    begin
	 set @ErrCode = -9
	 set @ErrMsg = 'ExternalTraffic can not be null, must be 1 or 0'
	 set @ErrCode = 10
	 raiserror(@ErrMsg,16,1)
	end --if

	set @ErrCode = -11

  if (@LetterType is null)
   begin
    set @ErrCode = -12
    set @ErrMsg = 'LetterType can not be null'
    set @ErrCode = 13
    raiserror(@ErrMsg,16,1)
   end --if

  set @ErrCode = -14

  if(@DeliverToLocation is null)
   begin
    set @ErrCode = -15
    set @ErrMsg = 'DeliverToLocation can not be null'
    set @ErrCode = 16
    raiserror(@ErrMsg,16,1)
   end --if

  set @ErrCode = -17

  if(@IsInbound is null)
   begin
    set @ErrCode = -18
    set @ErrMsg = 'IsInbound can not be null'
    set @ErrCode = 19
    raiserror(@ErrMsg,16,1)
   end --if

   set @ErrCode = -20

   set @SystemIDID = null
   select @SystemIDID = SystemID
   from t_system
   
   set @ErrCode = -21
   
   if(@SystemID is not null)
    begin
     set @SystemIDID = null
     select @SystemIDID = SystemID
      from t_System
      where sys_SystemID = @SystemID
   
   if(@SystemIDID is null)
    begin
     set @ErrCode = -22
     set @ErrMsg = 'Sys_SystemID ' + @SystemID + ' not recognized'
     set @ErrCode = 23
     raiserror(@ErrMsg,16,1) 
    end
   end --if

   if(@SystemIDID is null)
   begin
   set @ErrCode = -22
   set @ErrMsg = 'SystemID ' + @SystemIDID + ' can not be null'
   set @ErrCode = 23
   raiserror(@ErrMsg,16,1)
   end --if

   set @LetterTypeID = null
   Select @LetterTypeID = LetterTypeID 
   from t_LetterType
   set @ErrCode = -24

   if(@LetterTypeID is null)
   begin
   set @ErrCode = -25
   set @ErrMsg = 'LetterType ' +@LetterTypeID+ ' doest not exist'
   set @ErrCode = 26
   raiserror(@ErrMsg,16,1)
   end --if

   set @ErrCode = -27

   set @OrganisationUnitID = null
   select @OrganisationUnitID = OrganisationUnitID
   from t_OrganisationUnit
   where org_SORID = @SORID
   or org_LocationEAN = @LocationEAN
   or org_LocationSKS = @LocationSKS

   set @ErrCode = -28

   if( @OrganisationUnitID is null)
   begin
   set @ErrCode = -29
   set @ErrMsg = 'No matching EAN/SKS/SORID found(' +case when @LocationEAN is null then 'null' else @LocationEAN end +'/' + isnull(@LocationSKS, 'null' ) + '/' + isnull(@SORID, 'null')
   raiserror(@ErrMsg,16,1)
   end --if

   set @ErrCode = -30

   if(exists (select * 
   from t_OrganisationUnit_LetterType_MessageDirection
   where old_t_OrganisationUnitID = @OrganisationUnitID 
   and old_t_LetterTypeID = @LetterTypeID
   and old_t_SystemID = @SystemIDID
   and old_IsInBound = @IsInBound))
   begin
   set @ErrCode = -2
   update t_OrganisationUnit_LetterType_MessageDirection
   set old_t_SystemID = @SystemIDID, 
    old_ReceiveFromLocation = @ReceiveFromLocation,
	old_Active = @Active,
	old_UpdateTS = @UpdateTS,
	old_Remarks = @Remarks,
	old_InternalTraffic = @InternalTraffic,
	old_ExternalTraffic = @ExternalTraffic
   where old_t_OrganisationUnitID = @OrganisationUnitID 
    and old_t_LetterTypeID = @LetterTypeID
    and old_t_SystemID = @SystemIDID
    and old_IsInbound = @IsInbound
	set @ErrCode = -2
	end
   else
insert into dbo.t_OrganisationUnit_LetterType_MessageDirection
	(
		old_t_OrganisationUnitID,
		old_t_LetterTypeID,
		old_t_SystemID,
		old_ReceiveFromLocation,
		old_DeliverToLocation,
		old_IsInbound,
		old_Active,
		old_UpdateTS,
		old_Remarks,
		old_InternalTraffic,
		old_ExternalTraffic
	)
	values
	(
		@OrganisationUnitID,
		@LetterTypeID,
		@SystemIDID,
		@ReceiveFromLocation,
		@DeliverToLocation,
		@IsInbound,
		@Active,
		@UpdateTS,
		@Remarks,
		@InternalTraffic,
		@ExternalTraffic
	)
	set @ErrCode = 0
	end try

	begin catch

	 begin
	  set @ErrorNumber    = error_number()
      set @ErrorSeverity  = error_severity()
      set @ErrorState     = error_state()
      set @ErrorLine      = error_line()
      set @ErrorProcedure = isnull(error_procedure(), '-')
      set @ErrorMessage   = error_message()


      set @ErrorMessage = 'ERROR : Number = ' + cast(@ErrorNumber as nvarchar(10)) + ', ' + 
                         'Severity = ' + cast(@ErrorSeverity as nvarchar(10)) + ', ' + 
		   	             'Line = ' + cast(@ErrorLine as nvarchar(10)) + ', ' + 
					  	  case when @ErrorProcedure like '-' then '' else 'Procedure = ' + @ErrorProcedure end + ', ' + 
                          'Message = ' + @ErrorMessage + case when @ErrCode is null then '' 
                                                              else '<<' + cast(@ErrCode as nvarchar(20)) + '>>' end 
   raiserror (@ErrorMessage, 
             @ErrorSeverity, 
             1, 
             @ErrorNumber,    
             @ErrorSeverity,  
             @ErrorState,     
             @ErrorProcedure, 
             @ErrorLine)


	  

     exec rssp_AddError 'InsertLetterLog', @ErrCode, @ErrorMessage
    
     return @ErrCode
	end -- else  
  end catch



end
go