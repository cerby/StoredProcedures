use CloverleafRSD
go

				alter procedure rssp_VarIntStatistic

						@Input			nvarchar(400),
						@IntInput		int, 
						@FromTable		nvarchar(256), --table you are joining on
						@InpTbColumn	nvarchar(256), --column in said table
						@LetTblID		nvarchar(256), --FK in lettertable
						@InpTblID		nvarchar(256), --Matching key in inputs table
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
	declare @SQL			nvarchar(2000)
	declare @Parmdef		nvarchar(1000)
	declare @Intcvt			nvarchar(200)

begin try

 if(@Input is not null or @IntInput is not null)
  begin
   if(@Input is not null)
    begin
   
   set @ErrCode = -1


   set @SQL = ' select @ParmValidnvar  = ' +@InpTbColumn+
			  ' from ' +@FromTable+
			  ' where ' +@InpTbColumn+ ' = ''' +@Input+ ''' '

   set @Parmdef = '@ParmValidnvar nvarchar(200) OUTPUT, @ParmInpTbColumn nvarchar(200), @ParmFromTable nvarchar(200), @ParmInput nvarchar(200) '

   exec sp_ExecuteSQL @SQL,
					  @Parmdef,
					  @ParmInpTbColumn		= @InpTbColumn,
					  @ParmFromTable		= @FromTable,
					  @ParmInput			= @Input,
					  @ParmValidnvar		= @Validnvar output
		
		
		if(@Validnvar is null)
		 begin
		  set @ErrCode = -2
		  set @ErrMsg = +@InpTbColumn+ ' ' +@Input+ ' is not valid'
		  raiserror(@ErrMsg,16,1)
		 end
	end

   if(@IntInput is not null)
    begin
	 set @ErrCode = -3
	 set @intcvt = CONVERT(nvarchar(200),@IntInput)

	 set @SQL = ' select @ParmValidInt =' +@InpTbColumn+
				' from ' +@FromTable+
				' where ' +@InpTbColumn+ ' = ''' +@Intcvt+ ''' '

	 
	 set @Parmdef = '@ParmValidInt int OUTPUT, @ParmInpTbColumn nvarchar(200), @ParmFromTable nvarchar(200), @ParmIntInput int '

	 exec sp_ExecuteSQL @SQL,
						@Parmdef,
						@ParmInpTbColumn	= @InpTbColumn,
						@ParmFromTable		= @FromTable,
						@ParmIntInput		= @IntInput,
						@ParmValidInt		= @ValidInt output



	 if(@ValidInt is null)
	  begin
	   set @ErrCode = -4
	   set @ErrMsg = +@InpTbColumn+ ' ' +@Intcvt+ ' is not valid'
	   raiserror(@ErrMsg,16,1)
	  end

	end
	
	if(@Validnvar is not null or @ValidInt is not null)
	 begin
	 if charindex('llo_t_MessageStatusID', @InpTbColumn)>0
	  begin
	   set @InpTbColumn = 'mst_Name as MessageStatus'
	  end

	  if charindex(@InpTbColumn, @Select) = 0
	   begin
	    set @Select += ', ' +@InpTbColumn
	   end

	  if charindex(@FromTable, @From) = 0
	   begin
	    set @From += ' join '  +@FromTable + ' on '+@LetTblID+ ' = ' +@InpTblID+' '
	   end
	  
	  if charindex('mst_Name', @InpTbColumn)>0
	   begin
	    set @From += 'join t_MessageStatus on llo_t_MessageStatusID = MessageStatusId' 
	   end

	  if (@Where != ' ')
	   begin
	    set @Where += ' and'
	   end
	   
	  if(@Validnvar is not null)
	   begin
		set @Where += ' '+@InpTbColumn+' = ''' +@Input+ ''' '
	   end
	  
	  if(@ValidInt is not null)
	   begin
	    set @InpTbColumn = 'llo_t_MessageStatusID'
	    set @where += ' '+@InpTbColumn+ ' = ''' +@intcvt+ ''' '
	   end
	 end
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