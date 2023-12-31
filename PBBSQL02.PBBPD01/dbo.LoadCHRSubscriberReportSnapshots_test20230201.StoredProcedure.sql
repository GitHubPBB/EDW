USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[LoadCHRSubscriberReportSnapshots_test20230201]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[LoadCHRSubscriberReportSnapshots_test20230201] @StartDate Date, @EndDate Date
AS
BEGIN  
 SET NOCOUNT ON

--Declare @StartDate Date='2022-12-01 00:00:00'
--Declare @EndDate Date ='2022-12-31 23:59:59'

--------------------------------------------------------------------
--Code Section 1: Gather CHR Account Location Activity Data
---------------------------------------------------------------------

SELECT * 
INTO #AccountLocationActivity
FROM PBBSQL01.[PBB_ClientWorkspace].[dbo].CHR_AccountLocationActivity_test20230201
WHERE LoadDateTime = ( SELECT MAX(loaddatetime) 
					   FROM PBBSQL01.[PBB_ClientWorkspace].[dbo].CHR_AccountLocationActivity_test20230201
					 )
;

/*
--The following can be used to remove the latest snapshot FROM CHR_SubscriberReportSnapshots
begin tran
Declare @LoadDateTime datetime 
SELECT @LoadDateTime=MAX(LoadDateTime) FROM PBBSQL02.PBBPDW01.dbo.CHR_SubscriberReportSnapshots
Delete FROM PBBSQL02.PBBPDW01.dbo.CHR_SubscriberReportSnapshots WHERE LoadDateTime=@LoadDateTime
--commit tran
*/

-------------------------------------------------------------------------------
--Code Section 2: Delete existing data in a rerun scenario for the input month
-------------------------------------------------------------------------------

DELETE FROM PBBPDW01.dbo.CHR_SubscriberReportSnapshots_test20230201
WHERE StartDate = @StartDate AND
	  EndDate = @EndDate
	  ;

--------------------------------------------------------------------------------
--Code Section 3: Insert data into CHR_SubscriberReportSnapshots
--------------------------------------------------------------------------------

WITH AccountLocations AS
(
	SELECT DISTINCT RTRIM(ca.AccountCode) AS AccountNumber, CAST([AccountBase].Name AS varchar(100)) AS AccountName, 
		   ca.AccountID, AccountStatusCode, sl.LocationID, sl.FullLocation, 
		   [AccountMarket] = CAST(SUBSTRING([chr_AccountGroupBase].[cus_Market], 4, 255) AS varchar(100)), 
		   [AccountType] = CAST([chr_AccountTypeBase].[chr_Name] AS varchar(100)),
		   [AccountGroup] = CAST([chr_AccountGroupBase].[chr_Name] AS varchar(100)),
		   ala.ConnectDate, ala.DisconnectDate, ala.LoadDateTime
	FROM pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.cusaccount ca JOIN 
		 #AccountLocationActivity ala ON (ala.AccountID = ca.AccountID) JOIN 
		 pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.SrvLocationSearch sl ON (sl.LocationID = ala.LocationID) LEFT JOIN 
		 pbbsql01.[PBB_P_MSCRM].[dbo].[AccountBase] AS [AccountBase] ON (ca.[AccountID] = [AccountBase].[chr_AccountId]) LEFT JOIN 
		 pbbsql01.[PBB_P_MSCRM].[dbo].[chr_AccountGroupBase] AS [chr_AccountGroupBase] ON ([AccountBase].[chr_AccountGroupId] = [chr_AccountGroupBase].[chr_AccountGroupId]) LEFT JOIN 
		 pbbsql01.[PBB_P_MSCRM].[dbo].[chr_AccountTypeBase] AS [chr_AccountTypeBase] ON [AccountBase].[chr_AccountTypeId] = [chr_AccountTypeBase].[chr_AccountTypeId]
),
DistinctAccountLocations AS
(
	SELECT DISTINCT dal.AccountNumber, dal.AccountName, dal.AccountID, dal.AccountStatusCode, dal.LocationID, dal.FullLocation, dal.AccountMarket,
			CASE WHEN dal.AccountGroup = 'BVU Wholesale' THEN 'WHS' 
				ELSE LEFT(dal.AccountGroup, 3) 
			END AS Market,
			CASE WHEN dal.AccountType = 'Write Off' AND ag.AccountClassCode = 'S' THEN 'Residential'
          		 WHEN dal.AccountType = 'Write Off' AND ag.AccountClassCode = 'C' THEN 'Business' 
				ELSE dal.AccountType 
			END AS AccountType, 
			dal.AccountGroup, dal.LoadDateTime
	FROM AccountLocations dal LEFT JOIN 
		 pbbsql01.OMNIA_EPBB_P_PBB_CM.dbo.CusAccountGroup ag ON (ag.AccountGroup = dal.AccountGroup collate database_default)
),
BeginCounts AS
(
	SELECT al.AccountID,al.AccountNumber,al.LocationID,al.AccountMarket, al.AccountType, al.AccountGroup, 
		   MAX(al.ConnectDate) AS ConnectDate, 
		   COUNT(*) As BeginCount 
	FROM AccountLocations al
	WHERE al.ConnectDate < CONVERT(DateTime, DATEDIFF(DAY, 0, @StartDate)) AND 
		  ISNULL(al.DisconnectDate,'20790101') >= CONVERT(DateTime, DATEDIFF(DAY, 0, @StartDate))
	GROUP BY al.AccountID,al.AccountNumber,al.LocationID,al.AccountMarket, al.AccountType, al.AccountGroup
),
NewInstalls AS
(
	SELECT al.AccountID,al.AccountNumber,al.LocationID,al.AccountMarket, al.AccountType, al.AccountGroup, 
		   COUNT(*) As Install, 
		   MIN(al.ConnectDate) AS InstallDate 
	FROM AccountLocations al
	WHERE al.ConnectDate >= CONVERT(DateTime, DATEDIFF(DAY, 0, @StartDate)) AND 
		  al.ConnectDate < CONVERT(DateTime, DATEDIFF(DAY, -1, @EndDate)) AND 
		  ISNULL(al.DisconnectDate,'20790101') >= CONVERT(DateTime, DATEDIFF(DAY, -1, @EndDate))
	GROUP BY al.AccountID,al.AccountNumber,al.LocationID,al.AccountMarket, al.AccountType, al.AccountGroup
),
NewDisconnects AS 
(
	SELECT al.AccountID,al.AccountNumber,al.LocationID, al.AccountMarket, al.AccountType, al.AccountGroup, 
		   COUNT(*) As Disconnect, 
		   MAX(al.DisconnectDate) AS DisconnectDate 
	FROM AccountLocations al 
	WHERE ISNULL(al.DisconnectDate,'20790101') >= CONVERT(DateTime, DATEDIFF(DAY, 0, @StartDate)) AND 
		  ISNULL(al.DisconnectDate,'20790101') < CONVERT(DateTime, DATEDIFF(DAY, -1, @EndDate))
			AND al.ConnectDate < CONVERT(DateTime, DATEDIFF(DAY, 0, @StartDate))
	GROUP BY al.AccountID,al.AccountNumber,al.LocationID,al.AccountMarket, al.AccountType, al.AccountGroup
)
INSERT INTO PBBSQL02.PBBPDW01.dbo.CHR_SubscriberReportSnapshots_test20230201
	(StartDate, EndDate, LoadDateTime, AccountMarket, Market, AccountType, AccountGroup, AccountNumber, AccountName, LocationID, FullLocation, 
	 ConnectDate, InstallDate, DisconnectDate, BeginCount, InstallCount, DisconnectCount, EndCount)
SELECT @StartDate AS StartDate, @EndDate AS EndDate, al.LoadDateTime, al.AccountMarket, al.Market,
		al.AccountType, al.AccountGroup, 
		al.AccountNumber, al.AccountName, al.LocationID, al.FullLocation, 
		CASE WHEN b.AccountNumber IS NOT NULL THEN b.ConnectDate ELSE i.InstallDate END AS ConnectDate, 
		i.InstallDate, d.DisconnectDate,
		CASE WHEN b.AccountNumber IS NOT NULL THEN 1 ELSE 0 END AS BeginCount, 
		CASE WHEN i.AccountNumber IS NOT NULL THEN i.Install ELSE 0 END AS InstallCount, 
		CASE WHEN d.AccountNumber IS NOT NULL THEN -d.Disconnect ELSE 0 END AS DisconnectCount,
		(  --End Count Calc
		CASE WHEN b.AccountNumber IS NOT NULL THEN 1 ELSE 0 END +
		CASE WHEN i.AccountNumber IS NOT NULL THEN i.Install ELSE 0 END + 
		CASE WHEN d.AccountNumber IS NOT NULL THEN -d.Disconnect ELSE 0 END) AS EndCount
FROM DistinctAccountLocations al LEFT JOIN 
	 BeginCounts b ON 
		( b.AccountID = al.AccountID AND 
		  b.LocationID = al.LocationID
		) LEFT JOIN 
	NewInstalls i ON 
		( i.AccountID = al.AccountID AND 
		  i.LocationID = al.LocationID
		) LEFT JOIN 
	NewDisconnects d ON 
		( d.AccountID = al.AccountID AND 
		  d.LocationID=al.LocationID
		)
WHERE b.AccountNumber IS NOT NULL OR 
	  i.AccountNumber IS NOT NULL OR 
	  d.AccountNumber IS NOT NULL 
ORDER BY al.AccountNumber, al.LocationID, al.AccountMarket, al.AccountType, al.AccountGroup
;

DROP TABLE #AccountLocationActivity
;

END

GO
