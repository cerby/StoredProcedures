USE CloverleafRSD
GO

/****** Object:  StoredProcedure [dbo].[rssp_Insert_I_t_system]    Script Date: 08/20/2014 10:49:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


			create procedure rssp_Insert_I_t_system

				@SystemIDID		int, --not null
				@ControlTRXId	int,
				@SystemID		nvarchar(200), --not null
				@WantsControls	bit, -- not null
				@Email			nvarchar(200),
				@DisplayName	nvarchar(200),
				@Description	text
				
as
begin
  declare @ErrorMessage   nvarchar(4000)
  declare @ErrorNumber    int
  declare @ErrorSeverity  int
  declare @ErrorState     int
  declare @ErrorLine      int
  declare @ErrorProcedure nvarchar(200) 

  declare @ErrCode int
  declare @ErrMsg  nvarchar(100)
 
 Set @ErrCode = -1
 
 begin try
 	
 Set @ErrCode = -2
 if (@SystemID is null)
  begin
   set @ErrCode = -3
   set @ErrMsg = 'systemID must not be null'
   set @ErrCode = 4
   raiserror(@ErrMsg,16,1)
  end --if
 
 set @ErrCode =-5
 
 if (@WantsControls is null)
  begin
   set @ErrCode = -6
   set @ErrMsg = 'wantscontrols must not be null'
   set @ErrCode = 5
   raiserror(@ErrMsg,16,1)
  end --if
 
 set @ErrCode = -7

 if(exists (select*
  from t_System
  where SystemID = @SystemIDID
   and sys_SystemID = @SystemID
   and sys_WantsControls = @WantsControls))
  begin
   update t_System
   set sys_t_ControlTRXId = @ControlTRXId, 
    sys_Email = @Email, 
    sys_DisplayName = @DisplayName,
    sys_Description = @Description
   where SystemID = @SystemIDID 
    and sys_SystemID = @SystemID
    and sys_WantsControls = @WantsControls 
 end --if

  set @ErrCode = -8

insert into dbo.t_System
	(
	SystemID,
	sys_t_ControlTRXId,
	sys_SystemID,
	sys_WantsControls,
	sys_Email,
	sys_DisplayName,
	sys_Description
	)
	values
	(
	@SystemIDID,
	@ControlTRXId,
	@SystemID,
	@WantsControls,
	@Email,
	@DisplayName,
	@Description
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
   

     exec rssp_AddError 'InsertLetterLog', @ErrCode, @ErrorMessage
    
     return @ErrCode
	end -- else  
  end catch
	
end

GO


