USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_LargeCustomers]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PBB_LargeCustomers]
AS
	with accountcomment
		as (select a.AccountCode
				,c.CommentCode
		    from FactComment f
			    join DimComment c on f.DimCommentId = c.DimCommentId
			    join DimAccount a on f.DimAccountId = a.DimAccountId
		    where c.CommentCode = 'kca'),
		maxRunPerCycle
		as (select max(billingrunid) billingrunid
		    from DimBillingRun
		    where billingcycleid <> 0
		    group by BillingCycleID),
		accountbill
		as (select a.AccountCode
				,RecurringAmount
		    from FactBilledAccount f
			    join DimAccount a on f.DimAccountId = a.DimAccountId
			    join DimBillingRun br on f.DimBillingRunId = br.DimBillingRunId
			    join maxRunPerCycle mr on br.BillingRunID = mr.billingrunid
		    where RecurringAmount >= 1000)
		select f.*
			 ,ab.RecurringAmount
			 ,ac.CommentCode
		from FactCustomerAccount f
			join DimAccount a on f.DimAccountId = a.DimAccountId
			left join accountcomment ac on a.AccountCode = ac.AccountCode
			left join accountbill ab on a.AccountCode = ab.AccountCode
		where f.EffectiveStartDate <= getdate()
			 and f.EffectiveEndDate > getdate()
			 and (ac.AccountCode is not null
				 or ab.AccountCode is not null)
GO
