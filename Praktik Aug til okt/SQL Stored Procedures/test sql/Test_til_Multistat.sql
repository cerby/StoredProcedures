

use CloverleafRSD
go

declare @Select nvarchar(4000)
declare @From nvarchar(4000)

set @Select = ' '
set @From = ' '

exec rssp_Multistat '550105Z;550102A;5501028;5501219;550105J;550145J;550105E;550145E',
					';',
					' org_LocationSKS ',
					' Send ',
					@Select out,
					@From out

select *
From ##Temp_S_SKS

select @Select as solect, @From as Forom