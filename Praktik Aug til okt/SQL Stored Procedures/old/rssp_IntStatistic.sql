


use CloverleafRSD
go


			alter procedure rssp_IntStatistic

					@IntInput			int,
					@FromTable			nvarchar(256),
					@InpTbCol			nvarchar(256),
					--@LetterColumn		nvarchar(256),
					@LetTblID			nvarchar(256), --FK in lettertable
					@InpTblID			nvarchar(256), --PK in input table
					@Select				nvarchar(4000) output,
					@From				nvarchar(4000) output,
					@Where				nvarchar(4000) output


as 
begin

	declare @ErrorMessage   nvarchar(4000)
	declare @ErrorNumber    int
	declare @ErrorSeverity  int
	declare @ErrorState     int
	declare @ErrorLine      int
	declare @ErrorProcedure nvarchar(200) 

	declare @ErrCode		int
	declare @ErrMsg			nvarchar(100)
	declare @ValidInt		datetime
	declare @SQL			nvarchar(200)
	declare @ParamDef		nvarchar(200)

begin try

	set @ErrCode = -1

	if(@IntInput is not null)
	 begin
	  set @ValidInt = null
	
	set @ErrCode = -2

	select @ValidInt = llo_t_MessageStatusID 
	from t_LetterLog
	where llo_t_MessageStatusID = @IntInput
/*
	set @SQL = ' select '+@ValidInt+' = ' +@InpTbCol
			 + ' from	'+@FromTable
			 + ' where	'+@InpTbCol+ ' = ' +@IntInput

	set @ParamDef ='@ParamInpTbCol nvarchar(400), @ParamFromTable nvarchar(400), @ParamIntInput int, @ParamValidInt int OUTPUT '

	exec sp_ExecuteSQL @SQL,
					   @ParamDef,
					   @ParamInpTbCol		= @InpTbCol,
					   @ParamFromTable		= @FromTable,
					   @ParamIntInput		= @IntInput,
					   @ParamValidInt		= @ValidInt OUTPUT
*/
	 set @ErrCode = -3

	if(@ValidInt is null)
	 begin
	  set @ErrCode = -4
	  set @ErrMsg = +@InpTbCol+ ' ' +@IntInput+ ' is not valid'
	  set @ErrCode = 5
	  raiserror(@ErrMsg,16,1)
	 end

	set @ErrCode = -6

	if(@ValidInt is not null)
	 begin
	 if charindex(@FromTable, @From) = 0
		 begin
		  set @From += ' join '  +@FromTable + ' on '+@LetTblID+ ' = ' +@InpTblID+' '
		 end --if t_LetterLog
		  if charindex(' = ', @Where) > 0
		   begin
		    set @Where += ' and'
		   end
		    set @Where += ' '+@IntInput+ ' = '+@InpTbCol+ ' '
		   
		  if charindex( @InpTbCol, @Select) = 0
		   begin
		    set @Select += @InpTbCol
		   end
		   
	   end --if
   end
	
	set @ErrCode = -7  

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
 end 
end catch

end
go