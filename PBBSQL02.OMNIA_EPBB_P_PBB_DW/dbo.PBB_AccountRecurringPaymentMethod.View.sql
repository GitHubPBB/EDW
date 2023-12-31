USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_AccountRecurringPaymentMethod]    Script Date: 12/5/2023 3:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[PBB_AccountRecurringPaymentMethod] as
SELECT P.AccountCode, 'Recurring Card' Method
FROM   PBBSQL01.PaymentProcessor.dbo.PaymentProfile PP INNER JOIN
         PBBSQL01.PaymentProcessor.dbo.Profile P ON PP.ProfileId = P.ProfileId
WHERE (PP.Recurring = 1) AND (PP.RecurringEndDate IS NULL) AND (PP.RecurringStartDate IS NOT NULL)
and accountcode is not null
union
select AccountCode, 'ACH' from dimaccount where AccountACHBankName <> '' and AccountACHEndDate is null
GO
