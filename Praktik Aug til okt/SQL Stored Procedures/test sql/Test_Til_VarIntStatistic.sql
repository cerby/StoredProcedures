	--declare @Lettertype nvarchar(200)
	declare @Select			nvarchar(4000)
	declare @From			nvarchar(4000)
	declare @Where			nvarchar(4000)
	declare @LetLog			nvarchar(50)
	declare @LloID			nvarchar(50)
	declare @MessageStatus	int

	set @Select = ' '
	set @From = ' t_Letter '
	set @Where = ' '
	set @LetLog = ' t_LetterLog '
	set @LloID = ' llo_t_LetterID '
	set @MessageStatus = 2

	exec rssp_VarIntStatistic null,
						   @MessageStatus,
						   @LetLog,
						   ' llo_t_MessageStatusID ',
						   ' LetterID ',
						   @LloID,
						   @Select out,
						   @From out,
						   @Where out

	select @Select as salect, @From as Fram, @Where as Whare

	/*
	set @Lettertype = 'CTL02'
	
	
	exec rssp_VarIntStatistic @Lettertype,
							null,
						   ' t_LetterType ',
						   ' lty_Name ',
						   ' let_t_LetterTypeID ',
						   ' LetterTypeID ',
						   @Select out,
						   @From out,
						   @Where out
*/