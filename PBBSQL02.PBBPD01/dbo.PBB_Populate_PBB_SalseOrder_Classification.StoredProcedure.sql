USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_PBB_SalseOrder_Classification]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[PBB_Populate_PBB_SalseOrder_Classification]
as
    begin
	   truncate table [dbo].[PBB_SalesOrder_Classification]

	   insert into [dbo].[PBB_SalesOrder_Classification]
			select [SalesOrderId]
				 ,[SalesOrderNumber]
				 ,[SalesOrderName]
				 ,[ServiceLocationFullAddress]
				 ,[DimServiceLocationId]
				 ,[LocationId]
				 ,[AccountId]
				 ,[CreatedOn]
				 ,[DimAccountId]
				 ,[Order Review Date]
				 ,[SLADimServiceLocationID]
				 ,[SLADimAccountID]
				 ,[LocationAccountActivationDate]
				 ,[LocationAccountDeactivationDate]
				 ,[rownumber]
				 ,[SalesOrderClassification]
			from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_SalesOrder_Classification_View]
    end
GO
