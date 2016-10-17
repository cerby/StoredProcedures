	declare @Select			nvarchar(4000)
	declare @From			nvarchar(4000)
	declare @Where			nvarchar(4000)
	declare @LetLog			nvarchar(200)
	declare @LloID			nvarchar(200)
	declare @Process		nvarchar(200)
	
	set @Select = ' '
	set @From = ' t_Letter '
	set @Where = ' '
	set @LetLog = ' t_LetterLog '
	set @LloID = ' llo_t_LetterID '
	set @Process = 'nat_SRV065_DkLabRpt_raw'
	
	exec rssp_VarStatistic @Process,
						   null,
						   @LetLog,
						   ' llo_LoggingProcess ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out

	select @Select as scelect, @From as forum, @Where as wha

	select distinct llo_LoggingProcess
	from t_LetterLog