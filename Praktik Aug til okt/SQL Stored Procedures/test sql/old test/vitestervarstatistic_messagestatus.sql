	declare @Select			nvarchar(4000)
	declare @From			nvarchar(4000)
	declare @Where			nvarchar(4000)
	declare @LetLog			nvarchar(200)
	declare @LloID			nvarchar(200)
	declare @MessageStatus	int
	
	set @Select = ' '
	set @From = ' t_Letter '
	set @Where = ' '
	set @LetLog = ' t_LetterLog '
	set @LloID = ' llo_t_LetterID '

	set @MessageStatus = 2
	exec rssp_VarStatistic null,
						   @MessageStatus,
						   @LetLog,
						   ' llo_t_MessageStatusID ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out
	select @Select as scelect, @From as forum, @Where as wha