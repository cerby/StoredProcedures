-->>Start select of SenderEAN(Multistat proc)
   
   if(@SenderEAN is not null)
    begin
	 -------------------------
	 set @Delimit = ';' --this needs to be between each number for split to occur
	 -------------------------
	 declare @Temp_S_EAN		table(S_EAN nvarchar(200)) --temporary table variable

	  select @MultiStart = 1, @MultiEnd = charindex(@Delimit, @SenderEAN) --start at 1 , end at 1st delimiterlocation

	   set @ErrCode = -11

	    while @MultiStart < len(@SenderEAN) +1 --whileloop start, run while start has a lower number than the total length of SenderEAN+1 (so it gets the last one too)
		 begin
		  if (@MultiEnd = 0)
	       begin
			set @MultiEnd = len(@SenderEAN) +1 --if no delimiter is found, end will be the length of senderEAN+1
		   end --multi

			set @ErrCode = -12

			 Insert into @Temp_S_EAN
			  values(substring(@SenderEAN, @MultiStart, @MultiEnd-@MultiStart))	 -- insert the value of the substring into Temp_S_EAN

			set @ErrCode = -13

			set @MultiStart = @MultiEnd +1
			set @MultiEnd = charindex(@Delimit, @SenderEAN, @MultiStart)

			set @ErrCode = -14

		 end --while
 
	 set @ErrCode = -15
	
	end --if not null	 

-->>start select of SenderSHAK
	 
	 if (@SenderSHAK is not null)
	  begin
	  -------------------------
	   set @Delimit = ';' --this needs to be between each number for split to occur
	 -------------------------
	   declare @Temp_S_SHAK		table(S_SHAK nvarchar(200))
	  	  
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
 
		set @ErrCode = -20

	end --if not null
-->>Start check of SenderSORID

	if (@SenderSORID is not null)
	 begin
	 -------------------------
	 set @Delimit = ';' --this needs to be between each number for split to occur
	 -------------------------
	  declare @Temp_S_SORID		table(S_SORID nvarchar(200))

	  select @MultiStart = 1, @MultiEnd = charindex(@Delimit, @SenderSORID)

	set @ErrCode = -21

	 while @MultiStart < len(@SenderSORID) +1
	  begin
	   if (@MultiEnd = 0)
	    begin
		 set @MultiEnd = len(@SenderSORID) +1
		end

	set @ErrCode = -22

	 Insert into @Temp_S_SORID
	  values(substring(@SenderSORID, @MultiStart, @MultiEnd-@MultiStart))

	set @ErrCode = -23

	set @MultiStart = @MultiEnd +1
	set @MultiEnd = charindex(@Delimit, @SenderSORID, @MultiStart)

	set @ErrCode = -24

	 end --while
 
	set @ErrCode = -25
	 
	 end --if not null

-->>Start check of RecieverEAN

	if(@RecieverEAN is not null)
	 begin
	 -------------------------
	 set @Delimit = ':' --this needs to be between each number for split to occur
	 -------------------------
	  declare @Temp_R_EAN		table(R_EAN nvarchar(200))

	  select @MultiStart = 1, @MultiEnd = charindex(@Delimit, @RecieverEAN)

	set @ErrCode = -26

	 while @MultiStart < len(@RecieverEAN) +1
	  begin
	   if (@MultiEnd = 0)
	    begin
		 set @MultiEnd = len(@RecieverEAN) +1
		end

	set @ErrCode = -27

	 Insert into @Temp_R_EAN
	  values(substring(@RecieverEAN, @MultiStart, @MultiEnd-@MultiStart))

	set @ErrCode = -28

	set @MultiStart = @MultiEnd +1
	set @MultiEnd = charindex(@Delimit, @RecieverEAN, @MultiStart)

	set @ErrCode = -29

	 end --while
 
	set @ErrCode = -30

	 end --if not null

-->>Start check of RecieverSHAK

	if (@RecieverSHAK is not null)
	 begin
 	 -------------------------
	 set @Delimit = ':' --this needs to be between each number for split to occur
	 -------------------------

	  declare @Temp_R_SHAK		table(R_SHAK nvarchar(200))

	  select @MultiStart = 1, @MultiEnd = charindex(@Delimit, @RecieverSHAK)

	set @ErrCode = -31

	 while @MultiStart < len(@RecieverSHAK) +1
	  begin
	   if (@MultiEnd = 0)
	    begin
		 set @MultiEnd = len(@RecieverSHAK) +1
		end

	set @ErrCode = -32

	 Insert into @Temp_R_SHAK
	  values(substring(@RecieverSHAK, @MultiStart, @MultiEnd-@MultiStart))

	set @ErrCode = -33

	set @MultiStart = @MultiEnd +1
	set @MultiEnd = charindex(@Delimit, @RecieverSHAK, @MultiStart)

	set @ErrCode = -34

	 end --while
 
	set @ErrCode = -35
	 
	 end --if not null

-->>Start check of RecieverSORID
	
	if (@RecieverSORID is not null)
	 begin
	 -------------------------
	 set @Delimit = ':' --this needs to be between each number for split to occur
	 -------------------------
	  declare @Temp_R_SORID		table(R_SORID nvarchar(200))

	  select @MultiStart = 1, @MultiEnd = charindex(@Delimit, @RecieverSORID)

	set @ErrCode = -36

	 while @MultiStart < len(@RecieverSORID) +1
	  begin
	   if (@MultiEnd = 0)
	    begin
		 set @MultiEnd = len(@RecieverSORID) +1
		end

	set @ErrCode = -37

	 Insert into @Temp_R_SORID
	  values(substring(@RecieverSORID, @MultiStart, @MultiEnd-@MultiStart))

	set @ErrCode = -38

	set @MultiStart = @MultiEnd +1
	set @MultiEnd = charindex(@Delimit, @RecieverSORID, @MultiStart)

	set @ErrCode = -39

	 end --while
 
	set @ErrCode = -40
	 
	 end --if not null
	

	if(@SenderEAN is not null
	 or @SenderSHAK is not null
	 or @SenderSORID is not null
	 or @RecieverEAN is not null
	 or @RecieverSHAK is not null
	 or @RecieverSORID is not null)
	 begin
	set @ErrCode = -41
	 --set @Select += ' , org_Name , org_Address , org_PhoneNumber , org_Active '  
	  if charindex(' t_LetterType ', @From) = 0
	   begin
	    set @From += ' join t_LetterType on let_t_LetterTypeID = LetterTypeID '
	   end
		--join messagedirection
	   set @From += ' join t_OrganisationUnit_LetterType_MessageDirection on LetterTypeID = old_t_LetterTypeID'
	    --join orgunit
	   set @From += ' join t_OrganisationUnit on OrganisationUnitID = old_t_OrganisationUnitID'
	   
	    if(@SenderEAN is not null)
		 begin	
		  create table #TempS_EAN(TEMPSEAN nvarchar(200))	  	
	      --join Temptbl
		  --set @Select += ' , org_LocationEAN as SenderEAN '
		  set @From += ' join Temp_S_EAN on org_LocationEAN = S_EAN '
		  
		  if charindex(' = ',@Where) > 0
		   begin
			set @Where += ' and '
		   end
			set @Where += 'S_EAN = org_LocationEAN'
		 end
		
		if(@SenderSHAK is not null)
		 begin
		  --join Temptbl
		  --set @Select += ' , org_LocationSKS as SenderSHAK '
		  set @From += ' join Temp_S_SHAK on org_LocationSKS = S_SHAK '
		  
		  if charindex(' = ',@Where) > 0
		   begin
			set @Where += ' and '
		   end
			set @Where += 'S_SHAK = org_LocationSKS'
		 end

		if(@SenderSORID is not null)
		 begin
		  --join Temptbl
		  --set @Select += ' , org_SORID as SenderSORID '
		  set @From += ' join Temp_S_SORID on org_SORID = S_SORID '
		  
		  if charindex(' = ',@Where) > 0
		   begin
			set @Where += ' and '
		   end
			set @Where += 'S_SORID = org_SORID'
		 end

		if(@RecieverEAN is not null)
		 begin
		  --join Temptbl
		  --set @Select += ' , org_LocationEAN as RecieverEAN '
		  set @From += ' join Temp_R_EAN on org_LocationEAN = R_EAN '
		  
		  if charindex(' = ',@Where) > 0
		   begin
			set @Where += ' and '
		   end
			set @Where += 'R_EAN = org_LocationEAN'
		 end

		if(@RecieverSHAK is not null)
		 begin
		  --join Temptbl
		  --set @Select += ' , org_LocationSKS as RecieverSHAK '
		  set @From += ' join Temp_R_SHAK on org_LocationSKS = R_SHAK '
		  
		  if charindex(' = ',@Where) > 0
		   begin
			set @Where += ' and '
		   end
			set @Where += 'R_SHAK = org_LocationSKS'
		 end

		if(@RecieverSORID is not null)
		 begin
		  --join Temptbl
		  --set @Select += ' , org_SORID as RecieverSORID '
		  set @From += ' join Temp_R_SORID on org_SORID = R_SORID '
		  
		  if charindex(' = ',@Where) > 0
		   begin
			set @Where += ' and '
		   end
			set @Where += 'R_SORID = org_SORID'
	  end
	 end --if senders+recievers not null

	 set @ErrCode = -42

