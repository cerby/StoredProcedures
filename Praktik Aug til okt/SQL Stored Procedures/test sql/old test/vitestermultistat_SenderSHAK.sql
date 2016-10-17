	declare @MultiStart		int
	declare @MultiEnd		int
	declare @ErrCode		int
	declare @Delimit		nvarchar(2)
	declare @SenderShak		nvarchar(2000)
	declare @Select			nvarchar(4000)
	declare @From			nvarchar(4000)
	declare @Where			nvarchar(4000)
	declare @Temp_S_SHAK		table(S_SHAK nvarchar(200))

	set @Delimit = ';'
	set @Select = ' '
	set @From = ' t_Letter '
	set @Where = ' '
	set @SenderShak ='550105Z;550102A;5501028;5501219;550105J;550145J;550105E;550145E'
	
	  	  
		select @MultiStart = 1, @MultiEnd = charindex(@Delimit, @SenderSHAK)

		set @ErrCode = -16

		 while @MultiStart < len(@SenderSHAK) +1
		  begin
		   if (@MultiEnd = 0)
		    begin
		     set @MultiEnd = len(@SenderSHAK) +1
		    end

		    set @ErrCode = -17

			 Insert into @Temp_S_SHAK
			  values(substring(@SenderSHAK, @MultiStart, @MultiEnd-@MultiStart))

			  set @ErrCode = -18

			  set @MultiStart = @MultiEnd +1
			  set @MultiEnd = charindex(@Delimit, @SenderSHAK, @MultiStart)

			  set @ErrCode = -19

		 end --while
		 
		 if(@SenderSHAK is not null)
		 begin
		  --join Temptbl
		  set @Select += ' , org_LocationSKS'
		  set @From += ' join Temp_S_SHAK on org_LocationSKS = S_SHAK '
		  
		  if charindex(' = ',@Where) > 0
		   begin
			set @Where += ' and '
		   end
			set @Where += 'S_SHAK = org_LocationSKS'
		 end

	select @Select as scelect, @From as forum, @Where as wha

	select S_SHAK
	from @Temp_S_SHAK