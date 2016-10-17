create view vw_Routes as
  select old_t_OrganisationUnitID, old_t_LetterTypeID, old_t_SystemID, old_ReceiveFromLocation,
		 old_DeliverToLocation, old_IsInbound, old_Active, old_UpdateTS, old_Remarks, old_InternalTraffic,
		 old_ExternalTraffic, org_t_OrganisationUnitID, org_SORID, org_t_HospitalID, org_t_LocationTypeID, org_LocationEAN, 
		 org_LocationSKS, org_LocationSKSTypeCode, org_LocationSKSUnique, org_Name, org_Address, org_t_PostCodeID,
		 org_PhoneNumber, org_Fax, org_EMail, org_WebSite, org_Active, sys_t_ControlTRXId, sys_SystemID, sys_WantsControls,
		 sys_Email, sys_DisplayName, sys_Description

  from t_OrganisationUnit_LetterType_MessageDirection 
	   join t_OrganisationUnit on t_OrganisationUnit.OrganisationUnitID = t_OrganisationUnit_LetterType_MessageDirection.old_t_OrganisationUnitID
				join t_System on t_OrganisationUnit_LetterType_MessageDirection.old_t_SystemID = t_System.SystemID
go