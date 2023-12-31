USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[PBB_PromotionStatus]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create VIEW [dbo].[PBB_PromotionStatus] AS

SELECT AccountCode,pcr.ProductComponent AS ProductOffering,Priceplan,ComponentCode,component,ip.Begindate,pss.NumberofRecurrences,
	EndDate = CASE WHEN NumberofRecurrences  < 999 THEN DATEADD(Month,CAST(pss.NumberofRecurrences AS int),ip.BeginDate)
		WhEN NumberofRecurrences >= 999 THEN '2079-01-01 00:00:00'
		WhEN NumberofRecurrences IS NULL THEN '2079-01-01 00:00:00'
		END,
	Status = CASE
		WhEN NumberofRecurrences >= 999 THEN 'Active'
		WhEN NumberofRecurrences IS NULL THEN 'Active'
		WHEN NumberofRecurrences  < 999 AND DATEADD(Month,CAST(pss.NumberofRecurrences AS int),ip.BeginDate) < GETDATE() THEN 'Expired'
		WHEN NumberofRecurrences  < 999 AND DATEADD(Month,CAST(pss.NumberofRecurrences AS int),ip.BeginDate) > GETDATE() THEN 'Active'
		END,
		i.Itemid, i.Locationid
FROM pbbsql01.omnia_epbb_p_pbb_cm.dbo.SrvItemPrice ip
JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.PriPrice p ON ip.PriceID = p.PriceID
JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.PriPricePlan pp ON p.PriceplanID = pp.PriceplanID
JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.SrvItem i ON ip.ItemID = i.ItemID
JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.srvService s ON i.ServiceiD = s.ServiceID
JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.PrdproductComponent pcr oN s.RootProductComponentID = pcr.ProductcomponentID
JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.CusAccount ca ON s.AccountID = ca.AccountID
JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.prdcomponent c ON i.ComponentiD = c.ComponentiD
JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.PriPricestep ps ON p.PriceiD = ps.PriceID
JOIN pbbsql01.omnia_epbb_p_pbb_cm.dbo.PriPriceStepSchedule pss ON ps.PricestepID = pss.PriceStepID AND Occurrence = 1
WHERE ip.finalCycleScheduleID IS NULL AND NumberOfRecurrences <> 999

GO
