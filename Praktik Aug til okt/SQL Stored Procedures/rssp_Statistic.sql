use CloverleafRSD
go


			alter procedure rssp_Statistic

				@SenderTimeFrom	datetime,		--letter
				@SenderTimeTo	datetime,		--letter
				@CLTimeFrom		datetime,		--letterlog
				@CLTimeTo		datetime,		--letterlog
				@Lettertype		nvarchar(200),	--letter join lettertype
				@MessageStatus	int,			--messagestatusid --letterlog
				@ServerName		nvarchar(200),  --letterlog
				@Site			nvarchar(200),  --letterlog
				@Process		nvarchar(200),  --letterlog
				@Thread			nvarchar(200),  --letterlog
				@SenderEAN		nvarchar(200),  --organisation (this and below are multi input)
				@SenderSORID	nvarchar(200),  --||--
				@SenderSHAK		nvarchar(200),  --||--
				@RecieverEAN	nvarchar(200),  --organisation
				@RecieverSORID	nvarchar(200),  --||--
				@RecieverSHAK	nvarchar(200)   --||--


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
	declare @ValidNvar		nvarchar(4000)
	declare @ValidInt		int
	declare @ValidDate		datetime		
	declare @Select			nvarchar(4000)
	declare @From			nvarchar(4000)
	declare @Where			nvarchar(4000)
	declare @LetLog			nvarchar(50)
	declare @LloID			nvarchar(50)
	declare @ParamDef		nvarchar(2000)
	declare @SQL1			nvarchar(4000)
	declare @MultiStart		int
	declare @MultiEnd		int
	declare @Delimit		nvarchar(2)

	set @ErrCode = -1
	
	set @Select = ' '
	set @From = ' t_Letter '
	set @Where = ' '
	set @LetLog = ' t_LetterLog '
	set @LloID = ' llo_t_LetterID '


begin try

	set @ErrCode = -2

-->>Start check of SenderTime (in t_letter)

if(@SenderTimeFrom is not null and @SenderTimeTo is not null)
 begin
	exec rssp_DateStatistic @SenderTimeFrom, 
							@SenderTimeTo, 
							' t_Letter ', 
							' let_SenderTimeStamp ', 
							null, 
							null,
							@Select out,
							@From out,
							@Where out
	
 end
	set @ErrCode = -3

-->>Start check of Cloverleaftime (in t_letterlog)
if(@CLTimeFrom is not null and @CLTimeTo is not null)
 begin
	exec rssp_DateStatistic @CLTimeFrom, --starttime
							@CLTimeTo, --endtime
							' t_LetterLog ',  --table with column to check
							' llo_TS ', --column in table you are checking
							' LetterID ', --foreign key matching in other table 
							' llo_t_LetterID ', --matching key in table you check
							@Select out, 
							@From out,
							@Where out
 end
	set @ErrCode = -4

-->>Start check of lettertype
if(@Lettertype is not null)
 begin
	exec rssp_VarIntStatistic @Lettertype, --input from user
							null, --int input from user (in case of messagestatus(1-7))
						   ' t_LetterType ', --table with column to check
						   ' lty_Name ', --column in table to check
						   ' let_t_LetterTypeID ', --foreign key in other table
						   ' LetterTypeID ', --matching key in table we check 
						   @Select out,
						   @From out,
						   @Where out
 end
	set @ErrCode = -5
	
-->>start check of messagestatus
if(@MessageStatus is not null)
 begin
	exec rssp_VarIntStatistic null,
						   @MessageStatus,
						   @LetLog,
						   ' llo_t_MessageStatusID ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out
 end
	set @ErrCode = -6

-->>Start check of servername
if(@ServerName is not null)
 begin
	exec rssp_VarIntStatistic @ServerName,
						   null,
						   @LetLog,
						   ' llo_LoggingServer ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out
 end
	set @ErrCode = -7

-->>start check of site
if(@Site is not null)
 begin
	exec rssp_VarIntStatistic @Site,
						   null,
						   @LetLog,
						   ' llo_LoggingSite ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out
 end
	set @ErrCode = -8

-->>Start check of process
if(@Process is not null)
 begin
	exec rssp_VarIntStatistic @Process,
						   null,
						   @LetLog,
						   ' llo_LoggingProcess ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out
 end
	set @ErrCode = -9

-->>Start check of thread
if(@Thread is not null)
 begin
	exec rssp_VarIntStatistic @Thread,
						   null,
						   @LetLog,
						   ' llo_LoggingThread ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out
 end
	set @ErrCode = -10

-->>Start list of SenderEAN

--Use ' Send ' for sender and ' Rec ' for receiver
if(@SenderEAN is not null)
 begin
	exec rssp_Multistat @SenderEAN,
						';', --This is the delimiter, gotta be between every id
						' org_LocationEAN ', --column in table this matches
						' Send ',  --This specifies whether it is a list of senders or a list of recievers
						@Select out, 
						@From out
 end
	set @ErrCode = -11

-->>Start list of RecieverEAN
if(@RecieverEAN is not null)
 begin
	exec rssp_Multistat @RecieverEAN,
						':',
						' org_LocationEAN ',
						' Rec ',
						@Select out,
						@From out
 end
	set @ErrCode = -12

-->>Start list of SenderSKS/SHAK
if(@SenderSHAK is not null)
 begin
	exec rssp_Multistat @SenderSHAK,
						';',
						' org_LocationSKS ',
						' Send ',
						@Select out,
						@From out
 end
	set @ErrCode = -13

-->>Start list of ReceiverSKS/SHAK
if(@RecieverSHAK is not null)
 begin
	exec rssp_Multistat @RecieverSHAK,
						':',
						' org_LocationSKS ',
						' Rec ',
						@Select out,
						@From out
 end
	set @ErrCode = -14

-->>Start list of SenderSORID
if(@SenderSORID is not null)
 begin
	exec rssp_Multistat @SenderSORID,
						';',
						' org_SORID ',
						' Send ',
						@Select out,
						@From out
 end
	set @ErrCode = -15

-->>Start list of RecieverSORID
if(@RecieverSORID is not null)
 begin
	exec rssp_Multistat @RecieverSORID,
						':',
						' org_SORID ',
						' Rec ',
						@Select out,
						@From out
 end
-->>start select

-->>add additional columns to select statement
if(@Select != ' ')
 begin
		set @Select = RIGHT(@Select, LEN(@Select) - 1)  -- to remove the first comma
--generate SQL statement for sp_ExecuteSQL

	set @SQL1 = ' select '	+@Select+
			  + ' from '	+@From+ ' '
			  + ' where '	+@Where+ ' '

	set @ParamDef = '@ParamSelect nvarchar(4000), @ParamFrom nvarchar(4000), @ParamWhere nvarchar(4000) '

	set @ErrCode = -16

	exec sp_ExecuteSQL @SQL1,
					   @ParamDef,
					   @ParamSelect = @Select,
					   @ParamFrom	= @From,
					   @ParamWhere	= @Where
 end
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
go		