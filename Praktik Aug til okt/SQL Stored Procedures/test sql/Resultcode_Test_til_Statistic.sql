 select   llo_TS , mst_Name as MessageStatus,  llo_LoggingSite ,  llo_LoggingProcess ,  llo_LoggingThread  
 from  t_Letter  join  t_LetterLog  on  LetterID  =  llo_t_LetterID  
				 join t_MessageStatus on llo_t_MessageStatusID = MessageStatusId  
 where    llo_TS  >= '2013-11-19 15:26:40.000' 
	 and  llo_TS  <= '2014-11-20 10:12:02.000'  
	 and llo_t_MessageStatusID = '1'  
	 and  llo_LoggingSite  = 'router_site'  
	 and  llo_LoggingProcess  = 'router'  
	 and  llo_LoggingThread  = 'fr_edifact'  