USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_FranchiseFeesByMonth]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
/*
select * from PBB_FranchiseFeesByMonth(2023,4)
*/
CREATE FUNCTION [dbo].[PBB_FranchiseFeesByMonth](
			 @year  int
			,@month int
								)
RETURNS @FranchiseFees TABLE(
					    YYYYMM           int
					   ,AccountCode      char(13)
					   ,AccountGroupCode varchar(20)
					   ,LocationId       int
					   ,RevenueGLAccount varchar(50)
					   ,Amount           money
					   )
AS
	BEGIN
	    insert INTO @franchiseFees
			 select br.BillingRunID / 100 as BillingRun
				  ,a.AccountCode
				  ,ac.AccountGroupCode
				  ,sl.LocationId
				  ,glm.RevenueGLAccount
				  ,[BilledTaxAmount] as [Amount]
			 from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactBilledTax] fbt
				 inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimBillingRun] br on br.DimBillingRunId = fbt.DimBillingRunId
				 inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccount] a on a.DimAccountId = fbt.DimAccountId
				 inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimAccountCategory] ac on ac.DimAccountCategoryId = fbt.DimAccountCategoryId
				 inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimServiceLocation] sl on sl.DimServiceLocationId = fbt.DimServiceLocationId
				 inner join [OMNIA_EPBB_P_PBB_DW].[dbo].[DimGLMap] glm on glm.DimGLMapId = fbt.DimGLMapId
			 where br.BillingRunID >= (@year * 10000) + (@month * 100)
				  and br.BillingRunID <= (@year * 10000) + (@month * 100) + 99
				  and [BilledTaxAmount] <> 0	-- Fill the table variable with the rows for your result set
				  and glm.RevenueGLAccount like '%franchise%'

	    RETURN
	END
GO
