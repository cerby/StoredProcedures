	declare @Select			nvarchar(4000)
	declare @From			nvarchar(4000)
	declare @Where			nvarchar(4000)
	declare @LetLog			nvarchar(200)
	declare @LloID			nvarchar(200)
	declare @ServerName		nvarchar(200)
	
	set @Select = ' '
	set @From = ' t_Letter '
	set @Where = ' '
	set @LetLog = ' t_LetterLog '
	set @LloID = ' llo_t_LetterID '
	set @ServerName = 'srvodecloapp02v.rsyd.net'
	
	exec rssp_VarStatistic @ServerName,
						   null,
						   @LetLog,
						   ' llo_LoggingServer ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out

select @Select as silect, @From as furom, @Where as whier