USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DB_Non-Pay_Disconnects]    Script Date: 12/5/2023 3:30:01 PM ******/
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
select * from [dbo].[PBB_DB_Non-Pay_Disconnects]('9/14/2021')
*/

CREATE FUNCTION [dbo].[PBB_DB_Non-Pay_Disconnects](
			@SinceDate date)
RETURNS TABLE
AS
	RETURN
		  (
			 select *
			 from
				 (
					select distinct 
						  a.AccountCode
						 ,ac.AccountGroupCode
						 ,a.AccountStatusCode -- added 2022/01/27
						 ,ac.CycleDescription as [Bill Cycle]
						 ,a.AccountName
						 ,a.BillingAddressStreetLine1
						 ,a.BillingAddressStreetLine2
						 ,a.BillingAddressCity
						 ,a.BillingAddressStateAbbreviation
						 ,a.BillingAddressPostalCode
						 ,case
							 when so.SalesOrderType = 'Non-Pay Disconnect'
							 then 'Non-Pay' else so.SalesOrderDisconnectReason
						  end as SalesOrderDisconnectReason
						  --,a.AccountActivationDate
						 ,ad.ActivationDate as AccountActivationDate
						 ,so.SalesOrderStatus
						 ,fso.CreatedOn_DimDateId as SalesOrderDate
						 ,cast(so.SalesOrderProvisioningDate as date) as SalesOrderProvisioningDate
						 ,so.SalesOrderType
						 ,ROW_NUMBER() over(partition by a.AccountCode
						  order by cast(so.SalesOrderProvisioningDate as date) desc) as [Row]
					from [OMNIA_EPBB_P_PBB_DW].[dbo].[FactSalesOrder] fso
						inner join DimAccount a on a.DimAccountId = fso.DimAccountId
						inner join DimAccountCategory ac on ac.DimAccountCategoryId = fso.DimAccountCategoryId
						inner join DimSalesOrder so on so.DimSalesOrderId = fso.DimSalesOrderId
						left join
						(
						    select [DimAccountId]
								,Min(LocationAccountActivationDate) as ActivationDate
						    from [OMNIA_EPBB_P_PBB_DW].[dbo].[PBB_ServiceLocationAccountALL]
						    group by [DimAccountId]
						) ad on ad.DimAccountId = a.DimAccountId
					where so.SalesOrderType in
										 (
										  'Non-Pay Disconnect'
										 ,'Disconnect'
										 )
						 and so.SalesOrderStatus != 'Canceled'
						 and cast(so.SalesOrderProvisioningDate as Date) >= @SinceDate
				 ) d
			 where [row] = 1
		  )
GO
