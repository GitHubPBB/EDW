USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_ValidatePrdComponentMap_OLD]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PBB_ValidatePrdComponentMap_OLD]
AS
    begin

	   set nocount on

	   insert INTO PrdComponentMap
							(ComponentID
							,ComponentCode
							,ComponentClassID
							,ComponentClass
							,Component
							)
			select Distinct 
				  pc.ComponentID
				 ,pc.ComponentCode
				 ,pc.ComponentClassID
				 ,pcc.ComponentClass
				 ,pc.Component
			from [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[PrdComponent] pc
			     inner join [PBBSQL01].[OMNIA_EPBB_P_PBB_CM].[dbo].[PrdComponentClass] pcc on pcc.ComponentClassID = pc.ComponentClassID
			where pc.ComponentID not in
								   (
									  select ComponentID
									  from PrdComponentMap
								   );


	   declare @count int

	   select @count = count(*)
	   from PrdComponentMap
	   where IsUsed = 1
		    and isnull(IsData,0) = 0
		    and isnull(IsPhone,0) = 0
		    and isnull(IsCable,0) = 0
		    and isnull(IsPromo,0) = 0
		    and isnull(IsSmartHome,0) = 0
		    and isnull(IsIgnored,0) = 0

	   select convert(varchar(10),ComponentID) as ComponentID
		    ,convert(varchar(10),ComponentClassID) as ComponentClassID
		    ,Component
		    ,'Components (' + convert(varchar(10),@count) + ')' as tabname
	   from PrdComponentMap
	   where IsUsed = 1
		    and isnull(IsData,0) = 0
		    and isnull(IsPhone,0) = 0
		    and isnull(IsCable,0) = 0
		    and isnull(IsPromo,0) = 0
		    and isnull(IsSmartHome,0) = 0
		    and isnull(IsIgnored,0) = 0
	   order by Component;

    end
GO
