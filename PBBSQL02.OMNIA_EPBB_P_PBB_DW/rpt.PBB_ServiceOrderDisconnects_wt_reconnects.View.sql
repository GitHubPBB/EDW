USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [rpt].[PBB_ServiceOrderDisconnects_wt_reconnects]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- select count(*) from rpt.PBB_ServiceOrderDisconnects;

-- DROP VIEW rpt.PBB_ServiceOrderDisconnects_wt_reconnects;

CREATE VIEW [rpt].[PBB_ServiceOrderDisconnects_wt_reconnects]
AS
WITH 
-- Accouts with Promise To Pay date
PTP_Date AS
(
				SELECT 
					aa.AccountCode,
					MAX(ptp.PromiseDate) as PromiseDate
				FROM pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArAccount      AS AA 
				JOIN pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArPromiseToPay AS PTP ON AA.AccountID = PTP.AccountID
				GROUP BY aa.AccountCode
)

-- Non pay Reconnect , this fetches reconnect after a temporary suspend
, NP_Reconnects AS
(
			SELECT 
				AccountCode,
				OrderReviewDate,
				ReconnectOrderReviewDate
			FROM
				(
				SELECT  
					sod.AccountCode,
					sod.LocationId,
					sod.OrderReviewDate,
					soc.OrderReviewDate as ReconnectOrderReviewDate,
					ROW_NUMBER() OVER (PARTITION BY sod.AccountCode,sod.OrderReviewDate ORDER BY soc.OrderReviewDate) rn
				FROM rpt.PBB_ServiceOrderDisconnects sod
				JOIN rpt.PBB_ServiceOrderConnects soc
					ON sod.AccountCode = soc.AccountCode
					-- AND sod.LocationId = soc.LocationId
					AND soc.OrderReviewDate >= sod.OrderReviewDate
					AND soc.SalesOrderClassification = 'Reconnect'
					AND sod.DisconnectType = 'Disconnect for Non Pay'--- Only Non-Pay disconnect
				) a
			WHERE a.rn = 1 -- fetch next reconnect order after disconnect order
)	
-- New Connects after permanent disconnect, this includes both reconnets after a disconnect and account install after a disconnect
, New_Connects AS
(
			SELECT 
				AccountCode,
				OrderReviewDate,
				InstallOrderReviewDate
			FROM
				(
				SELECT  
					sod.AccountCode,
					sod.OrderReviewDate,
					soc.OrderReviewDate as InstallOrderReviewDate,
					ROW_NUMBER() OVER (PARTITION BY sod.AccountCode,sod.OrderReviewDate ORDER BY soc.OrderReviewDate) rn
					-- ,soc.*
				FROM rpt.PBB_ServiceOrderDisconnects sod
				JOIN rpt.PBB_ServiceOrderConnects soc
					ON sod.AccountCode = soc.AccountCode
					-- AND sod.LocationId = soc.LocationId
					AND soc.OrderReviewDate >= sod.OrderReviewDate
					AND sod.DisconnectType = 'Voluntary Disconnect'	--- Only permanent disconnect
				LEFT JOIN NP_Reconnects np							--- Exclude accounts with non-pay Reconnect orders
					ON sod.AccountCode = np.AccountCode
					AND sod.LocationId = soc.LocationId
					AND sod.OrderReviewDate = np.OrderReviewDate
				--WHERE -- np.AccountCode IS NULL
				--sod.AccountCode = '100209155'
				) a
			WHERE a.rn = 1 -- fetch next install order after disconnect order
)

--- Main Dataset
SELECT  
  sod.AccountActivationDate	[Acct-ActivationDate]
, sod.BundleType	        [Acct-BundleType]
, sod.AccountClass	        [Acct-Class]
, sod.AccountCode	        [Acct-Code]
, sod.AccountCount	        [Acct-Count]
, sod.AccountDeactivationDate	[Acct-DeactivationDate]
, sod.AccountGroup	    [Acct-Group]
, sod.AccountGroupCode	[Acct-GroupCode]
, sod.AccountName       [Acct-Name]
, sod.PortalUserExists	[Acct-PortalUserExists]
, sod.PrintGroup	    [Acct-PrintGroup]
, sod.Speed	            [Acct-Speed]
--, Tenure	        [Acct-Tenure]
, sod.TenureRange    	[Acct-TenureRange]
--, TenureSort	    [Acct-TenureSort]
, case when sod.AccountType = 'COMMERCIAL'  then 'Business'
       when sod.AccountType = 'RESIDENTIAL' then 'Residential'
       else sod.AccountType end [Acct-Type]
, sod.WriteOffStatus    [Acct-WriteOffStatus]
, sod.CalcProjectName	[Addr-CalcProjectName]
, sod.ServiceLocationCity	        [Addr-City]
, sod.ServiceLocationFullAddress	[Addr-Full Address]
, sod.Cabinet                       [Addr-Cabinet]
, sod.Latitude	                    [Addr-Latitude]
, sod.Longitude      	            [Addr-Longitude]
, sod.ProjectName	                [Addr-ProjectName]
, sod.ServiceLocationStateAbbrev	[Addr-StateAbbrev]
, sod.AddressType	                [Addr-Type]
, sod.ServiceLocationZip	        [Addr-Zip]
, sod.DelinquentInvoicesLast6Months	[AR-DelinquentInvoicesLast6Months]
, sod.NonPayCountLast6Months	    [AR-NonPayCountLast6Months]
, sod.PaidInvoicesLast6Months	    [AR-PaidInvoicesLast6Months]
, sod.PartialPaidInvoicesLast6Months	[AR-PartialPaidInvoicesLast6Months]
, sod.PTPCountLast6Months	[AR-PTPCountLast6Months]
, sod.DimAccountId	        [Dim-AccountId]
, sod.DiscountAmount	    [Inv-DiscountAmount]
, sod.DiscountAmountMinus1	[Inv-DiscountAmountMinus1]
, sod.DiscountAmountMinus2	[Inv-DiscountAmountMinus2]
, sod.DiscountAmountMinus3	[Inv-DiscountAmountMinus3]
, sod.DiscountAmountMinus4	[Inv-DiscountAmountMinus4]
, sod.DiscountAmountMinus5	[Inv-DiscountAmountMinus5]
, sod.InvoiceAmount	        [Inv-InvoiceAmount]
, sod.InvoiceAmountMinus1	[Inv-InvoiceAmountMinus1]
, sod.InvoiceAmountMinus2	[Inv-InvoiceAmountMinus2]
, sod.InvoiceAmountMinus3	[Inv-InvoiceAmountMinus3]
, sod.InvoiceAmountMinus4	[Inv-InvoiceAmountMinus4]
, sod.InvoiceAmountMinus5	[Inv-InvoiceAmountMinus5]
-- , sod.LastInvoiceBilledMRC	[Inv-LastFullBilledMRC]
, sod.NonRecurringAmount	[Inv-NonRecurringAmount]
, sod.NonRecurringAmountMinus1	[Inv-NonRecurringAmountMinus1]
, sod.NonRecurringAmountMinus2	[Inv-NonRecurringAmountMinus2]
, sod.NonRecurringAmountMinus3	[Inv-NonRecurringAmountMinus3]
, sod.NonRecurringAmountMinus4	[Inv-NonRecurringAmountMinus4]
, sod.NonRecurringAmountMinus5	[Inv-NonRecurringAmountMinus5]
, sod.PaymentAmount	        [Inv-PaymentAmount]
, sod.PaymentAmountMinus1	[Inv-PaymentAmountMinus1]
, sod.PaymentAmountMinus2	[Inv-PaymentAmountMinus2]
, sod.PaymentAmountMinus3	[Inv-PaymentAmountMinus3]
, sod.PaymentAmountMinus4	[Inv-PaymentAmountMinus4]
, sod.PaymentAmountMinus5	[Inv-PaymentAmountMinus5]
, sod.PreviousBalanceAmount	[Inv-PreviousBalanceAmount]
, sod.PreviousBalanceAmountMinus1	[Inv-PreviousBalanceAmountMinus1]
, sod.PreviousBalanceAmountMinus2	[Inv-PreviousBalanceAmountMinus2]
, sod.PreviousBalanceAmountMinus3	[Inv-PreviousBalanceAmountMinus3]
, sod.PreviousBalanceAmountMinus4	[Inv-PreviousBalanceAmountMinus4]
, sod.PreviousBalanceAmountMinus5	[Inv-PreviousBalanceAmountMinus5]
, sod.RecurringAmount	        [Inv-RecurringAmount]
, sod.RecurringPaymentMethod	[Inv-RecurringPaymentMethod]
, sod.RecurringAmountMinus1	[Inv-RecurringAmountMinus1]
, sod.RecurringAmountMinus2	[Inv-RecurringAmountMinus2]
, sod.RecurringAmountMinus3	[Inv-RecurringAmountMinus3]
, sod.RecurringAmountMinus4	[Inv-RecurringAmountMinus4]
, sod.RecurringAmountMinus5	[Inv-RecurringAmountMinus5]
, sod.TotalDue	        [Inv-TotalDue]
, sod.TotalDueMinus1	[Inv-TotalDueMinus1]
, sod.TotalDueMinus2	[Inv-TotalDueMinus2]
, sod.TotalDueMinus3	[Inv-TotalDueMinus3]
, sod.TotalDueMinus4	[Inv-TotalDueMinus4]
, sod.TotalDueMinus5	[Inv-TotalDueMinus5]
--, LastInvYearMonth	[LastInvYearMonth]
--, LastInvYearMonthMinus1	LastInvYearMonthMinus1
--, LastInvYearMonthMinus2	LastInvYearMonthMinus2
--, LocationId	            LocationId
, sod.AccountMarket	[Mkt-AccountMarket]
, sod.MarketSummary	[Mkt-MarketSummary]
-- , sod.MarketSort    [Mkt-Sort]
, sod.ReportingMarket	[Mkt-ReportingMarket]
, sod.OrderActivityType	[Order-ActivityType]
, sod.SalesOrderChannel	[Order-Channel]
, sod.SalesOrderClassification	[Order-Classification]
, sod.SalesOrderCommitmentDate	[Order-CommitmentDate]
, sod.CompletionDate	[Order-CompletionDate]
, sod.DisconnectReason	[Order-DisconnectReason]
, case when sod.DisconnectType = 'NonPay' then 'NonPay' else sod.DisconnectReasonCategory	End [Order-DisconnectReasonCategory]
, sod.DisconnectType	[Order-DisconnectType]
, sod.SalesOrderFulfillmentStatus	[Order-FulfillmentStatus]
, sod.SalesOrderId	    [Order-Id]
, sod.SalesOrderName	[Order-Name]
, sod.SalesOrderNumber	[Order-Number]
, sod.SalesOrderOwner	[Order-Owner]
, sod.SalesOrderPriorityCode	[Order-PriorityCode]
, sod.SalesOrderProvisioningDate	[Order-ProvisioningDate]
, sod.OrderReviewDate	[Order-ReviewDate]
, sod.SalesOrderSegment	[Order-Segment]
, sod.SalesOrderStatus	[Order-Status]
, sod.SalesOrderStatusReason	[Order-StatusReason]
, sod.SalesOrderTotalAmount	[Order-TotalAmount]
, sod.SalesOrderTotalMRC	[Order-TotalMRC]
, sod.SalesOrderTotalNRC	[Order-TotalNRC]
, sod.SalesOrderTotalTax	[Order-TotalTax]
, sod.SalesOrderType	    [Order-Type]
, sod.Orig_InstallOrderChannel	[Orig-InstallChannel]
, sod.Orig_InstallOrderName	    [Orig-InstallName]
, sod.Orig_InstallOrderNumber	[Orig-InstallNumber]
, sod.Orig_InstallOrderBillReviewDate	[Orig-InstallOrderReviewDate]
, sod.Orig_InstallOrderOwner	            [Orig-InstallOwner]
, sod.Orig_SalesOrderProvisioningDate	[Orig-InstallProvisioningDate]
, sod.Orig_InstallSalesAgent  	[Orig-InstallSalesAgent]
, sod.Orig_InstallOrderSegment	[Orig-InstallSegment]
, sod.Orig_InstallStatus	[Orig-InstallStatus]
, sod.Orig_InstallType	[Orig-InstallType]
--, Selection_Flag	[Selection_Flag]
, sod.TroubleTicketsLast3Months	[TroubleTicket-CountLast3Months]
,np.ReconnectOrderReviewDate
,nc.InstallOrderReviewDate
,ptp.PromiseDate
FROM rpt.PBB_ServiceOrderDisconnects sod
LEFT JOIN NP_Reconnects np
	ON sod.AccountCode = np.AccountCode
	-- AND sod.LocationId = np.LocationId
	AND sod.OrderReviewDate = np.OrderReviewDate
LEFT JOIN New_Connects nc
	ON sod.AccountCode = nc.AccountCode
	-- AND sod.LocationId = snc.LocationId
	AND sod.OrderReviewDate = nc.OrderReviewDate
LEFT JOIN PTP_Date ptp
	ON ptp.AccountCode = sod.AccountCode
	AND ptp.PromiseDate >= sod.OrderReviewDate
	;
GO
