USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_ValidatePrdComponentMap]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE PROCEDURE [dbo].[PBB_ValidatePrdComponentMap]
AS
    begin

	   set nocount on;

	   insert INTO [dbo].[PrdComponentMap]
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
									  from [dbo].[PrdComponentMap]
								   );

	   declare @count int;

	   select @count = count(*)
	   from
		   (
			  select [ComponentID]
				   ,[ComponentCode]
				   ,[Component]
				   ,[ComponentClassID]
				   ,[ComponentClass]
			  from [OMNIA_EPBB_P_PBB_DW].[dbo].[PrdComponentMap]
			  where([IsIgnored] = 0
				   and [IsUsed] = 1)
				  and [IsData] = 0
				  and [IsDataSvc] = 0
				  and [SpeedTier] = 0
				  and [IsSmartHome] = 0
				  and [IsSmartHomePod] = 0
				  and [IsSmartHomePromo] = 0
				  and [IsPointGuard] = 0
				  and [IsPhone] = 0
				  and [IsLocalPhn] = 0
				  and [IsUnlimitedLD] = 0
				  and [IsCallPlan] = 0
				  and [NonPub] = 0
				  and [NonList] = 0
				  and [ForeignList] = 0
				  and [TollFree] = 0
				  and [ISDID] = 0
				  and [IsCable] = 0
				  and [IsCableSvc] = 0
				  and [HBOBulk] = 0
				  and [HBOSA] = 0
				  and [HBOQV] = 0
				  and [Cinemax_Standalone_SA] = 0
				  and [Cinemax_Standalone_QV] = 0
				  and [Cinemax_Pkg_SA] = 0
				  and [Cinemax_pkg_qv] = 0
				  and [Showtime_SA] = 0
				  and [Showtime_QV] = 0
				  and [Starz_SA] = 0
				  and [Starz_QV] = 0
				  and [IsHispanic] = 0
				  and [IsFreeHD] = 0
				  and [IsRF] = 0
				  and [IsIPTV] = 0
				  and [IsCableManual] = 0
				  and [IsPromo] = 0
				  and [IsNRC_Scheduling] = 0
				  and [IsOther] = 0
				  and IsTaxOrFee = 0
				  and ComponentClass <> 'Package'
		   ) d

	   select convert(varchar(10), [ComponentID]) as [ComponentID]
		    ,[ComponentCode]
		    ,[Component]
		    ,convert(varchar(10), [ComponentClassID]) as [ComponentClassID]
		    ,[ComponentClass]
		    ,'Components (' + convert(varchar(10),@count) + ')' as [tabname]
	   from [OMNIA_EPBB_P_PBB_DW].[dbo].[PrdComponentMap]
	   where([IsIgnored] = 0
		    and [IsUsed] = 1)
		   and [IsData] = 0
		   and [IsDataSvc] = 0
		   and [SpeedTier] = 0
		   and [IsSmartHome] = 0
		   and [IsSmartHomePod] = 0
		   and [IsSmartHomePromo] = 0
		   and [IsPointGuard] = 0
		   and [IsPhone] = 0
		   and [IsLocalPhn] = 0
		   and [IsUnlimitedLD] = 0
		   and [IsCallPlan] = 0
		   and [NonPub] = 0
		   and [NonList] = 0
		   and [ForeignList] = 0
		   and [TollFree] = 0
		   and [ISDID] = 0
		   and [IsCable] = 0
		   and [IsCableSvc] = 0
		   and [HBOBulk] = 0
		   and [HBOSA] = 0
		   and [HBOQV] = 0
		   and [Cinemax_Standalone_SA] = 0
		   and [Cinemax_Standalone_QV] = 0
		   and [Cinemax_Pkg_SA] = 0
		   and [Cinemax_pkg_qv] = 0
		   and [Showtime_SA] = 0
		   and [Showtime_QV] = 0
		   and [Starz_SA] = 0
		   and [Starz_QV] = 0
		   and [IsHispanic] = 0
		   and [IsFreeHD] = 0
		   and [IsRF] = 0
		   and [IsIPTV] = 0
		   and [IsCableManual] = 0
		   and [IsPromo] = 0
		   and [IsNRC_Scheduling] = 0
		   and [IsOther] = 0
		   and IsTaxOrFee = 0
		   and ComponentClass <> 'Package'
    end
GO
