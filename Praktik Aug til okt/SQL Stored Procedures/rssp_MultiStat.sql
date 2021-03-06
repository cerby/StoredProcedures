use CloverleafRSD
go

alter procedure rssp_Multistat

			@Input			nvarchar(4000),
			@delimit		nvarchar(2),
			--@FromTable		nvarchar(200), --no sense in having this, as it will always be OrganisationUnit
			@InpTbCol		nvarchar(200),
			@SendRec		nvarchar(20),
			@Select			nvarchar(4000) output,
			@From			nvarchar(4000) output
			--@Where			nvarchar(4000) output
			
			

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
	declare @IDSendRec		nvarchar(20) --to see if we are dealing with a sender or reciever and whether we are dealing with a sender or reciever
	declare @Start			int
	declare @End			int

begin try



 if(@Input is not null)
  begin	
	set @ErrCode = -1

	if (@InpTbCol = ' org_LocationEAN ' and @SendRec = ' Send ')
	 begin
	  set @IDSendRec = ' EANS '
	   if OBJECT_ID('tempdb..##Temp_S_EAN') is not null
	    drop table ##Temp_S_EAN
		 create table ##Temp_S_EAN (S_EAN nvarchar(200))		
	 end
	 
	set @ErrCode = -2

	if (@InpTbCol = ' org_LocationEAN ' and @SendRec = ' Rec ')
	 begin
	  set @IDSendRec = ' EANR '
	   if OBJECT_ID('tempdb..##Temp_R_EAN') is not null
	    drop table ##Temp_R_EAN
		 create table ##Temp_R_EAN (R_EAN nvarchar(200))
	 end
	 	   
	set @ErrCode = -3

	if (@InpTbCol = ' org_LocationSKS ' and @SendRec = ' Send ')
	 begin
	  set @IDSendRec = ' SKSS '
	   if OBJECT_ID('tempdb..##Temp_S_SKS') is not null
	    drop table ##Temp_S_SKS
		 create table ##Temp_S_SKS (S_SKS nvarchar(200))
	 end

	set @ErrCode = -4

	if (@InpTbCol = ' org_LocationSKS ' and @SendRec = ' Rec ')
	 begin
	  set @IDSendRec = ' SKSR '
	   if OBJECT_ID('tempdb..##Temp_R_SKS') is not null
	    drop table ##Temp_R_SKS
		 create table ##Temp_R_SKS (R_SKS nvarchar(200))
	 end

	set @ErrCode = -5
	
	if (@InpTbCol = ' org_SORID ' and @SendRec = ' Send ')
	 begin
	  set @IDSendRec = ' SORS '
	   if OBJECT_ID('tempdb..##Temp_S_SOR') is not null
	    drop table ##Temp_S_SOR
		 create table ##Temp_S_SOR (S_SOR nvarchar(200))
	 end

	 set @ErrCode = -6

	if (@InpTbCol = ' org_SORID ' and @SendRec = ' Rec ')
	 begin
	  set @IDSendRec = ' SORR '
	   if OBJECT_ID('tempdb..##Temp_R_SOR') is not null
	    drop table ##Temp_R_SOR
		 create table ##Temp_R_SOR (R_SOR nvarchar(200))
	 end

	 set @ErrCode = -7

	select @Start = 1, @End = charindex(@delimit, @Input)

	set @ErrCode = -8

	 while @Start < len(@Input) +1 
	  begin
	   if(@End = 0)
	    begin
		 set @End = Len(@Input) +1
		end				

		set @ErrCode = -9
	
		if (@IDSendRec = ' EANS ')
		 begin
		  Insert into ##Temp_S_EAN values(substring(@Input, @Start, @End - @Start))
		 end

		if (@IDSendRec = ' EANR ')
		 begin
		  Insert into ##Temp_R_EAN values(substring(@Input, @Start, @End - @Start))
		 end

		 if (@IDSendRec = ' SKSS ')
		 begin
		  Insert into ##Temp_S_SKS values(substring(@Input, @Start, @End - @Start))
		 end

		 if (@IDSendRec = ' SKSR ')
		 begin
		  Insert into ##Temp_R_SKS values(substring(@Input, @Start, @End - @Start))
		 end

		 if (@IDSendRec = ' SORS ')
		 begin
		  Insert into ##Temp_S_SOR values(substring(@Input, @Start, @End - @Start))
		 end

		 if (@IDSendRec = ' SORR ')
		 begin
		  Insert into ##Temp_R_SOR values(substring(@Input, @Start, @End - @Start))
		 end

		 set @Start = @End +1
		 set @End = charindex(@delimit, @Input, @Start)
		  -- start is now at end +1 and end will be at the next spot of a delimit
	/*
		Insert into @tempo
		 values(substring(@Input, @Start, @end - @start))
	
		--set @intowhere = substring(@Input, @Start, @end - @start)
	*/

	  end -- while
  	
	set @ErrCode = -10

	if charindex( ' t_LetterType ', @From) = 0
	 begin
	  set @From += ' join t_Lettertype on let_t_LetterTypeID = LetterTypeID '
	 end

	if charindex(' t_OrganisationUnit ', @From) = 0
	 begin
	  set @From += ' join t_OrganisationUnit_LetterType_MessageDirection on LetterTypeID = old_t_LetterTypeID '
	  set @From += ' join t_OrganisationUnit on old_t_OrganisationUnitID = OrganisationUnitID '
	 end

	if (@IDSendRec = ' EANS ')
	 begin
	  set @Select += ', S_EAN '
	  set @From += ' join ##Temp_S_EAN on org_LocationEAN = S_EAN '
	 end

	if (@IDSendRec = ' EANR ')
	 begin
	  set @Select += ', R_EAN '
	  set @From += ' join ##Temp_R_EAN on org_LocationEAN = R_EAN '
	 end

	if (@IDSendRec = ' SKSS ')
	 begin
	  set @Select += ', S_SKS '
	  set @From += ' join ##Temp_S_SKS on org_LocationSKS = S_SKS '
	 end 

	if (@IDSendRec = ' SKSR ')
	 begin
	  set @Select += ', R_SKS '
	  set @From += ' join ##Temp_R_SKS on org_LocationSKS = R_SKS '
	 end

	if (@IDSendRec = ' SORS ')
	 begin
	  set @Select += ', S_SOR '
	  set @From += ' join ##Temp_S_SOR on org_SORID = S_SOR '
	 end

	if (@IDSendRec = ' SORR ')
	 begin
	  set @Select += ', R_SOR '
	  set @From += ' join ##Temp_R_SOR on org_SORID = R_SOR '
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