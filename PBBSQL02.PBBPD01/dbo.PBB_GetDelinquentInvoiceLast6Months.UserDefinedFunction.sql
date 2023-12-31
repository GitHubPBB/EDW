USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_GetDelinquentInvoiceLast6Months]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_GetDelinquentInvoiceLast6Months](
			@PointInTime DATE)
RETURNS TABLE
AS
	RETURN
		  (
			select d.accountcode, d.accountid, count(br.BillingInvoiceDate) DelinquentInvoiceCount --, 
			--br.BillingMonthMMM, br.BillingYearYYYY, br.BillingYearMonth,
			--f.PreviousBillAmount, f.PreviousBalanceDelinquentAmount, f.PreviousBalanceAmount, f.InvoiceAmount, f.BilledAmount, f.TotalDue
			from FactBilledAccount f
			join DimBillingRun br on f.DimBillingRunId = br.DimBillingRunId
			join dimaccount d on f.DimAccountId = d.DimAccountId
			where f.dimaccountid <> 0
			and billinginvoicedate between (dateadd(month,-6,@PointInTime)) and @PointInTime
			and PreviousBalanceAmount > 20
			group by d.accountcode, d.accountid
			)
GO
