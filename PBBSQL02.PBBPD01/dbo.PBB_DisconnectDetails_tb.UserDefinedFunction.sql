USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_DisconnectDetails_tb]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_DisconnectDetails_tb](
			@ReportDate date)
RETURNS TABLE 
AS
RETURN 
(
WITH IsCustomerActive
     AS (SELECT DISTINCT 
                A.Dimaccountid, 
                DimServiceLocationId
         FROM FactCustomerItem f
              JOIN DimCustomerItem d  ON f.DimCustomerItemId = d.DimCustomerItemId
              JOIN DimAccount      A  ON F.DimAccountId      = A.DimAccountId
              JOIN DimCatalogItem  CI ON F.DimCatalogItemId  = CI.DimCatalogItemId
              JOIN PrdComponentMap cm ON ci.ComponentCode    = cm.ComponentCode
         WHERE     f.EffectiveStartDate <= GETDATE()
               AND f.EffectiveEndDate   >= GETDATE()
               AND itemstatus       = 'A'
               AND IsNRC_Scheduling = 0
               AND IsIgnored        = 0
     ),

     disco
     AS (SELECT DATEDIFF(month, accountactivationdate, ISNULL(AccountDeactivationDate, GETDATE())) Tenure, 
                a.dimaccountid acctid,
                CASE WHEN A.DimAccountID IS NOT NULL
                     THEN 'Y'
                     ELSE 'N'
                 END AS ReconnectedServices, 
                m.*, 
                isnull(b.PBB_BundleType,'None') PBB_BundleType
         FROM [dbo].[PBB_DB_MONTHLY_DETAIL](@ReportDate) m
              LEFT JOIN [dbo].[DimServiceLocationBundleType_pbb] b ON  m.dimaccountid = b.DimAccountId
                                                                   AND m.dimservicelocationid = b.DimServiceLocationID
																   and m.CreatedOn_DimDateId = b.AsOfDimDateID
              LEFT JOIN IsCustomerActive A ON  m.dimaccountid = a.dimaccountid
                                           AND A.DimServiceLocationId = m.dimservicelocationid
         WHERE SalesOrderType = 'Disconnect'
                                                                   --AND DisconnectReason = 'Total Disconnect for Non Pay'
     ),
     mininstall
     AS (SELECT v.dimaccountid, 
                v.dimservicelocationid, 
                MIN(pso.pbb_SalesOrderReviewDate) pbb_SalesOrderReviewDate

         FROM FactSalesOrder F
              JOIN DimSalesOrder         so  ON f.DimSalesOrderId = so.DimSalesOrderId
              JOIN DimSalesOrderView_pbb v   ON v.SalesOrderId    = so.SalesOrderId
              JOIN DimSalesOrder_pbb     pso ON so.salesorderid   = pso.salesorderid
         WHERE v.pbb_OrderActivityType = 'Install'
         GROUP BY v.DimAccountId, 
                  v.DimServiceLocationId
	 ),

     installs
     AS (SELECT DISTINCT 
                v.salesorderid, 
                v.pbb_OrderActivityType, 
                v.DimAccountId, 
                v.DimServiceLocationId, 
                so.SalesOrderNumber, 
                so.SalesOrderName, 
                so.SalesOrderChannel, 
                so.SalesOrderSegment, 
                so.SalesOrderOwner, 
                pso.pbb_SalesOrderReviewDate, 
                SalesOrderLineItemAgents

         FROM FactSalesOrderLineItem     f
              JOIN DimSalesOrderLineItem d   ON  f.DimSalesOrderLineItemId = d.DimSalesOrderLineItemId
              JOIN DimSalesOrder         so  ON  f.DimSalesOrderId = so.DimSalesOrderId
              JOIN DimSalesOrderView_pbb v   ON  v.SalesOrderId  = so.SalesOrderId
              JOIN DimSalesOrder_pbb     pso ON  so.salesorderid = pso.salesorderid
              JOIN mininstall            oi  ON  v.DimAccountId  = oi.DimAccountId
                                             AND v.DimServiceLocationId = oi.DimServiceLocationId
                                             AND pso.pbb_SalesOrderReviewDate = oi.pbb_SalesOrderReviewDate
         WHERE v.pbb_OrderActivityType = 'Install'
     )

     SELECT @ReportDate [Date],
	        i.pbb_ReportingMarket Market, 
            i.PBB_BundleType BundleType, 
            ad.AccountGroup, 
            i.AccountCode, 
            i.CustomerName, 
            ad.CurrentAccountStatus, 
            ad.ActivationDate, 
            ad.DeactivationDate, 
            i.Tenure, 
            i.ReconnectedServices, 
            coalesce(NP.NonPayCount,0) NonPayCountLast6Months, 
 			coalesce(Pay.PaidInvoicesLast6Months,0) PaidInvoicesLast6Months, 
            coalesce(Pay.PartialPaidInvoicesLast6Months,0) PartialPaidInvoicesLast6Months,
 			coalesce(PTP.PTPLast6Months,0) PTPLast6Months  ,
			DEL.DelinquentInvoiceCount,
--            NP.NonPayCount NonPayCountLast6Months, 
--			Pay.PaidInvoicesLast6Months , 
--            Pay.PartialPaidInvoicesLast6Months ,
--            PTP.PTPLast6Months   ,
			i.DimServiceLocationID,
            addr.ServiceLocationFullAddress, 
            addr.Latitude, 
            addr.Longitude, 
            ISNULL(addr.[Project Name], 'PC-UNIVERSAL') ProjectName, 
            DisconnectOrderNumber, 
            DisconnectorderName, 
            DisconnectOrderChannel, 
            DisconnectOrderSegment, 
            DisconnectReason, 
            CreatedOn_DimDateId DisconnectCreateDate, 
			DiscoOrderBillReviewDate,
            AD.PortalUserExists,
            CASE WHEN PrintGroup = 'Electronic Invoice'
                 THEN 'EBill'
                 ELSE 'Paper'
             END AS PrintGroup, 
            AD.[Recurring Payment Method], 
            i.Orig_InstallType, 
            i.Orig_InstallOrderNumber, 
            i.Orig_InstallOrderName, 
            i.Orig_InstallOrderChannel, 
            i.Orig_InstallOrderSegment, 
            i.Orig_InstallOrderOwner,
            CASE WHEN LEN(Orig_InstallSalesAgent) > 0
                 THEN RIGHT(Orig_InstallSalesAgent, LEN(Orig_InstallSalesAgent) - 1)
                 ELSE Orig_InstallSalesAgent
             END AS SalesAgent, 
            i.Orig_InstallOrderBillReviewDate
			
     FROM
     (
         SELECT d.pbb_ReportingMarket, 
                i.salesorderid          Orig_InstallOrderID, 
                i.pbb_OrderActivityType Orig_InstallType, 
                i.DimAccountId, 
                d.DimServiceLocationId, 
                i.SalesOrderNumber      Orig_InstallOrderNumber, 
                i.SalesOrderName        Orig_InstallOrderName, 
                i.SalesOrderChannel     Orig_InstallOrderChannel, 
                i.SalesOrderSegment     Orig_InstallOrderSegment, 
                i.SalesOrderOwner       Orig_InstallOrderOwner, 
                i.pbb_SalesOrderReviewDate Orig_InstallOrderBillReviewDate, 
                STRING_AGG(CONVERT(NVARCHAR(MAX), SalesOrderLineItemAgents), ', ') AS Orig_InstallSalesAgent, 
                d.Tenure, 
                d.ReconnectedServices, 
                d.PBB_BundleType, 
                d.accountcode, 
                d.CustomerName, 
                d.salesordernumber  DisconnectOrderNumber, 
                d.SalesOrderName    DisconnectOrderName, 
                d.SalesOrderChannel DisconnectOrderChannel, 
                d.SalesOrderSegment DisconnectOrderSegment, 
                d.DisconnectReason, 
                d.CreatedOn_DimDateId,
				d.[Order Review Date] DiscoOrderBillReviewDate

         FROM disco d
              LEFT JOIN installs i ON d.dimaccountid = i.DimAccountId
                                      AND d.dimservicelocationid = i.DimServiceLocationId
                                      AND i.pbb_SalesOrderReviewDate < d.CreatedOn_DimDateId
         GROUP BY d.pbb_ReportingMarket, 
                  d.Tenure, 
                  d.ReconnectedServices, 
                  d.PBB_BundleType, 
                  d.accountcode, 
                  d.CustomerName, 
                  d.salesordernumber, 
                  d.SalesOrderName, 
                  d.SalesOrderChannel, 
                  d.SalesOrderSegment, 
                  d.DisconnectReason, 
                  d.CreatedOn_DimDateId, 
                  i.salesorderid, 
                  i.pbb_OrderActivityType, 
                  i.DimAccountId, 
                  d.DimServiceLocationId, 
                  i.SalesOrderNumber, 
                  i.SalesOrderName, 
                  i.SalesOrderChannel, 
                  i.SalesOrderSegment, 
                  i.SalesOrderOwner, 
                  i.pbb_SalesOrderReviewDate, 
                  d.salesordernumber,
				  d.[Order Review Date]
     ) i
     LEFT JOIN PBB_AccountDetails    AD   ON i.AccountCode COLLATE SQL_Latin1_General_CP1_CI_AI = ad.AccountNumber COLLATE SQL_Latin1_General_CP1_CI_AI
     LEFT JOIN dimaddressdetails_pbb addr ON i.accountcode = addr.accountcode
                                                AND i.DimServiceLocationId = addr.DimServiceLocationId

	 LEFT JOIN PBB_GetDelinquentInvoiceLast6Months(@ReportDate) DEL on DEL.AccountCode = i.AccountCode

     OUTER apply PBB_GetNonPayLast6Months       (i.AccountCode,  i.CreatedOn_DimDateId ) NP  

	 OUTER apply PBB_GetPaymentCountLast6Months (i.AccountCode,  i.CreatedOn_DimDateId ) PAY 

 	 OUTER apply PBB_GetPTPCountLast6Months     (i.AccountCode,  i.CreatedOn_DimDateId ) PTP 

)
GO
