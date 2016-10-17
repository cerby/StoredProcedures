use CloverleafRSD
go


			alter procedure rssp_Statistic

				@SenderTimeFrom	datetime,		--letter
				@SenderTimeTo	datetime,		--letter
				@CLTimeFrom		datetime,		--letterlog
				@CLTimeTo		datetime,		--letterlog
				@Lettertype		nvarchar(200),	--letter join lettertype
				@MessageStatus	int,			--messagestatusid --letterlog
				@SenderEAN		nvarchar(200),  --organisation
				@SenderSORID	nvarchar(200),  --||--
				@SenderSHAK		nvarchar(200),  --||--
				@RecieverEAN	nvarchar(200),  --organisation
				@RecieverSORID	nvarchar(200),  --||--
				@RecieverSHAK	nvarchar(200),  --||--
				@ServerName		nvarchar(200),  --letterlog
				@Site			nvarchar(200),  --letterlog
				@Process		nvarchar(200),  --letterlog
				@Thread			nvarchar(200)   --letterlog

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
	declare @SQL1			nvarchar(200)
	declare @MultiStart		int
	declare @MultiEnd		int
	declare @Delimit		nvarchar(2)
	declare @SomeColumn		nvarchar(30)

	set @ErrCode = -1
	
	set @Select = ' '
	set @From = ' t_Letter '
	set @Where = ' '
	set @LetLog = ' t_LetterLog '
	set @LloID = ' llo_t_LetterID '


begin try

	set @ErrCode = -2

-->>Start check of SenderTime (in t_letter)


	exec rssp_DateStatistic @SenderTimeFrom,
							@SenderTimeTo,
							' t_Letter ',
							' let_SenderTimeStamp ',
							null,
							null,
							@Select out,
							@From out,
							@Where out
	

	set @ErrCode = -3

-->>Start check of Cloverleaftime (in t_letterlog)

	exec rssp_DateStatistic @CLTimeFrom,
							@CLTimeTo,
							@LetLog,
							' llo_TS ',
							' LetterID ',
							@LloID,
							@Select out,
							@From out,
							@Where out

	set @ErrCode = -4

-->>Start check of lettertype

	exec rssp_VarStatistic @Lettertype,
							null,
						   ' t_LetterType ',
						   ' lty_Name ',
						   ' let_t_LetterTypeID ',
						   ' LetterTypeID ',
						   @Select out,
						   @From out,
						   @Where out
	set @ErrCode = -5
	
-->>start check of messagestatus

	exec rssp_VarStatistic null,
						   @MessageStatus,
						   @LetLog,
						   ' llo_t_MessageStatusID ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out
	
	set @ErrCode = -6

-->>Start check of servername

	exec rssp_VarStatistic @ServerName,
						   null,
						   @LetLog,
						   ' llo_LoggingServer ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out

	set @ErrCode = -7

-->>start check of site

	exec rssp_VarStatistic @Site,
						   null,
						   @LetLog,
						   ' llo_LoggingSite ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out

	set @ErrCode = -8

-->>Start check of process
	
	exec rssp_VarStatistic @Process,
						   null,
						   @LetLog,
						   ' llo_LoggingProcess ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out

	set @ErrCode = -9

-->>Start check of thread

	exec rssp_VarStatistic @Thread,
						   null,
						   @LetLog,
						   ' llo_LoggingThread ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out

	set @ErrCode = -10

-->>Start list of SenderEAN

--Use ' Send ' for sender and ' Rec ' for receiver

	exec rssp_Multistat @SenderEAN,
						';', --This is the delimiter, gotta be between every id
						' org_LocationEAN ',
						' Send ',  --This specifies whether it is a list of senders or a list of recievers
						@Select out, 
						@From out

	set @ErrCode = -11

-->>Start list of RecieverEAN

	exec rssp_Multistat @RecieverEAN,
						':',
						' org_LocationEAN ',
						' Rec ',
						@Select out,
						@From out

	set @ErrCode = -12

-->>Start list of SenderSKS/SHAK

	exec rssp_Multistat @SenderSHAK,
						';',
						' org_LocationSKS ',
						' Send ',
						@Select out,
						@From out

	set @ErrCode = -13

-->>Start list of ReceiverSKS/SHAK

	exec rssp_Multistat @RecieverSHAK,
						':',
						' org_LocationSKS ',
						' Rec ',
						@Select out,
						@From out

	set @ErrCode = -14

-->>Start list of SenderSORID

	exec rssp_Multistat @SenderSORID,
						';',
						' org_SORID ',
						' Send ',
						@Select out,
						@From out

	set @ErrCode = -15

-->>Start list of RecieverSORID

	exec rssp_Multistat @RecieverSORID,
						':',
						' org_SORID ',
						' Rec ',
						@Select out,
						@From out
-->>start select

-->>add additional columns to select statement

	set @Select = RIGHT(@Select, LEN(@Select) - 1)  -- to remove the first comma
--generate SQL statement for sp_ExecuteSQL

	set @SQL1 = ' select'	+@Select+''
			  + ' from '	+@From+ ' '
			  + ' where '	+@Where+ ' '

	set @ParamDef = '@ParamSelect nvarchar(4000), @ParamFrom nvarchar(4000), @ParamWhere nvarchar(4000) '

	set @ErrCode = -16
	print @SQL1
	exec sp_ExecuteSQL @SQL1,
					   @ParamDef,
					   @ParamSelect = @Select,
					   @ParamFrom	= @From,
					   @ParamWhere	= @Where

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