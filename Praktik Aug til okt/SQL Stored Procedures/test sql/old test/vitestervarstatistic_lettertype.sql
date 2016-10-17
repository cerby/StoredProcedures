use CloverleafRSD
go

declare @Select nvarchar(100) set @Select = ' '
declare @From nvarchar(200) set @From = ' '
declare @Where nvarchar(200) set @Where = ' '
declare @Lettertype nvarchar(200) set @Lettertype = 'REF02'



		exec rssp_VarStatistic @Lettertype,
							null,
						   ' t_LetterType ',
						   ' lty_Name ',
						   ' let_t_LetterTypeID ',
						   ' LetterTypeID ',
						   @Select out,
						   @From out,
						   @Where out

select @Select as silect, @From as furom, @Where as whier
