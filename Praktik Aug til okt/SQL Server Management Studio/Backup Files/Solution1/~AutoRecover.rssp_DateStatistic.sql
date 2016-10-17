


use CloverleafRSD
go


			alter procedure rssp_DateStatistic

					@DateInputStart		datetime,
					@DateInputEnd		datetime,
					@FromTable			nvarchar(256),
					@InpTbCol			nvarchar(256),
					--@LetterColumn		nvarchar(256),
					@LetTblID			nvarchar(256), --FK in lettertable
					@InpTblID			nvarchar(256), --PK in input table
					@Select				nvarchar(4000) output, 
					--input @select, this needs to get the new values added to the string, 
					--when procedure is done (return?)
					@From				nvarchar(4000) output,
					--some goes for the @from input
					@Where				nvarchar(4000) output --must not be null if you want to change its value
					--and same for the @where, 
					--they all need to get stuff added and to still have it upon exiting 


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
	declare @InptCvt1		nvarchar(200)
	declare @InptCvt2		nvarchar(200)

begin try


	if (@DateInputStart is not null and @DateInputEnd is not null)
	 begin
	  set @ErrCode = -1
	--check if @fromtable contains t_letter (this doesn't catch t_LetterLog)
	   if charindex(' t_Letter ', @FromTable) = 0 
		begin --if it doesn't, then check if the table is present already in our final from sentence (else skip this part)
		 if charindex(@Fromtable, @From) = 0
		  begin --if the table is not present in @From, then join it on the matching id in t_letter
		   set @From += ' join '  +@FromTable + ' on '+@LetTblID+ ' = ' +@InpTblID+' '
		  end --if t_LetterLog
		end --if t_letter

		 set @ErrCode = -2

		 set @InptCvt1 = convert(nvarchar(200), @DateInputStart, 121)
		 set @InptCvt2 = convert(nvarchar(200), @DateInputEnd, 121)


		--does our where sentence contain an equal sign (meaning is there stuff in it already)
		  if charindex(' = ', @Where) > 0
		   begin --if there is, then add an AND, 
		    set @Where += ' and '
		   end --now let our where sentence contain the needed column and data, needed to get the dates we want to see
		    set @Where += ' ' +@InpTbCol+' >= ''' +@InptCvt1+ '''  and ' +@InpTbCol+ ' <= ''' +@InptCvt2+ ''' ' 
		  --does the select sentence contain the input table column already? if not, then add it to the select sentence, else skip
		
		set @ErrCode = -3

		 if(@Select is not null)
		  begin
		   if charindex( @InpTbCol, @Select) = 0
		    begin
		     set @Select +=', ' +@InpTbCol
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