use CloverleafRSD
go

				alter procedure rssp_VarStatistic

						@Input			nvarchar(400),
						@IntInput		int, 
						@FromTable		nvarchar(256), --table you are joining on
						@InpTbColumn	nvarchar(256), --column in said table
						@LetTblID		nvarchar(256), --FK in lettertable
						@InpTblID		nvarchar(256), --PK in input table
						@Select			nvarchar(4000) output, -- select string to update to final query
						@From			nvarchar(4000) output,--From string to update to final query
						@Where			nvarchar(4000) output --where string to update to final query


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
	declare @Validnvar		nvarchar(400)
	declare @ValidInt		int
	declare @SQL			nvarchar(200)
	declare @parmdef		nvarchar(200)
	declare @intcvt			nvarchar(200)
	
begin try
 


 if(@Input is not null or @IntInput is not null)
  begin
   set @ErrCode = -1

   set @Validnvar = null
   set @ValidInt = null
 
	set @ErrCode = -2

	if charindex(' lty_Name ', @InpTbColumn) > 0
     begin
      select @Validnvar = lty_Name
	  from t_LetterType
	  where lty_Name like @Input
	  set @ErrCode = -3
     end



	if charindex(' llo_LoggingServer ', @InpTbColumn) > 0
     begin
	  select @Validnvar = llo_LoggingServer 
	  from t_LetterLog
	  where llo_LoggingServer = @Input
	  set @ErrCode = -4
	 end



	if charindex(' llo_LoggingSite ', @InpTbColumn)> 0
	 begin
	  select @Validnvar = llo_LoggingSite
	  from t_LetterLog
	  where llo_LoggingSite = @Input
	  set @ErrCode = -5
	 end



	if charindex(' llo_LoggingProcess ', @InpTbColumn) > 0
	 begin
	  select @Validnvar = llo_LoggingProcess
	  from t_LetterLog
	  where llo_LoggingProcess = @Input
	  set @ErrCode = -6
	 end



	if charindex(' llo_LoggingThread ', @InpTbColumn) > 0
	 begin
	  select @Validnvar = llo_LoggingThread
	  from t_LetterLog
	  where llo_LoggingThread = @Input
	  set @ErrCode = -7
	 end

	

	if charindex(' llo_t_MessageStatusID ',@InpTbColumn)>0
	 begin
	  select @ValidInt = llo_t_MessageStatusID 
	  from t_LetterLog
	  where llo_t_MessageStatusID = @IntInput
	  set @ErrCode = -8
	 end


  /*
   --make sure the input is valid through the use of sp_executesql
   set @SQL =' select @ParmInpTbColumn = ' +@InpTbColumn
			+' from   '+@FromTable
			+' where  '+@InpTbColumn+ ' = ' +@Input  

   set @parmdef = '@ParmInpTbColumn nvarchar(400), @ParmInput nvarchar(400), @ParmFromTable nvarchar(256), @ParmValidnvar nvarchar(400) OUTPUT'
   
   exec sp_ExecuteSQL @SQL,
					  @parmdef,
					  @ParmInpTbColumn		= @InpTbColumn,
					  @ParmFromTable		= @FromTable,
					  @ParmInput			= @Input,
					  @ParmValidnvar		= @Validnvar OUTPUT
	*/
	--@SQL	 select @ParmInput =  lty_Name  from    t_LetterType  where   lty_Name  =  REF02
	--Invalid column name 'REF02'.<<-2>>
	--Incorrect syntax near '='.<<-2>>
		
	--the thought here is that you should be able to do something similar to
	/*
	set @validater = null

	select @validater = tablecolumn
	from table
	where tablecolumn = input

	if(@validater is null)
	set @errmsg = you just blew the whole database
	then validater will either have the same value as input
	or it will be null. 
	can this be done with sp_executesql,
	if e.g. tablecolumn is an variable (@tablecolumn), table is @table and input is @input?

	*/


   if(@Validnvar is null and @ValidInt is null)
   begin 
	set @ErrMsg = +@InpTbColumn+ ' ' +@Input+ ' is not valid'
	set @ErrCode = 11
	raiserror(@ErrMsg,16,1)
   end

   if(@Validnvar is not null or @ValidInt is not null)
    begin
	 if charindex( @FromTable, @From) = 0
		 begin
		  set @From += ' join '  +@FromTable + ' on '+@LetTblID+ ' = ' +@InpTblID+' '
		 end 
		  if charindex(' = ', @Where) > 0
		   begin
		    set @Where += ' and'
		   end
		  if charindex('<=', @Where) > 0
		   begin
		    set @Where += ' and'
		   end
		   
		   if(@Validnvar is not null)
		    begin
		     set @Where += ' '+@InpTbColumn+' = ''' +@Input+ ''' '
			end
		   
		   if(@ValidInt is not null)
		    begin
			 set @intcvt = CONVERT(nvarchar(200),@IntInput)
		     set @where += ' '+@InpTbColumn+ ' = ''' +@intcvt+ ''' '
			end
		  
		  if charindex( @InpTbColumn, @Select) = 0
		   begin
		    set @Select += ', ' +@InpTbColumn
		   end
		   
	   end --if
	   set @ErrCode = 0
   end
	

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