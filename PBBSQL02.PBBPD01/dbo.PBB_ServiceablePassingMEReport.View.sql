USE [PBBPDW01]
GO
/****** Object:  View [dbo].[PBB_ServiceablePassingMEReport]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[PBB_ServiceablePassingMEReport] as
WITH Loc
     AS (SELECT DISTINCT 
                AddressNoPostal, 
                [Project Name], 
                ISNULL(Cabinet, '') Cabinet, 
                ISNULL(FundType, '') FundType, 
                [Wirecenter Region], 
                City, 
                State, 
                [Tax Area], 
                [Location Zone], 
                LocationIsServicable
         FROM DimAddressDetails_pbb d)
     SELECT DISTINCT 
            AddressNoPostal, 
            [Project Name], 
            Cabinet, 
            FundType, 
            [Wirecenter Region], 
            City, 
            State, 
            [Tax Area],
            CASE
                WHEN [Location Zone] = 'Unknown'
                THEN 'Not Specified'
                WHEN [Location Zone] = 'OFFNET'
                THEN 'Offnet'
                WHEN [Location Zone] IN('BRI', 'CPC', 'DUF')
                THEN 'VA-TN'
                WHEN [Location Zone] = 'BLD'
                THEN 'Baldwin-FTTH'
                WHEN [Location Zone] = 'SWG'
                THEN 'Colquitt-FTTH'
                WHEN [Location Zone] = 'OPL'
                THEN 'Opelika'
                WHEN [Location Zone] = 'ISL'
                THEN 'Island Fiber'
                WHEN [Location Zone] = 'MCH'
                THEN 'Michigan'
                WHEN [Location Zone] = 'OHI'
                THEN 'Ohio'
                WHEN [Location Zone] = 'NGA'
                THEN 'North Georgia'
                WHEN [Location Zone] = 'TAL'
                THEN 'Tallapoosa'
                WHEN [Location Zone] = 'HAG'
                THEN 'Hagerstown'
                WHEN [Location Zone] = 'NYK'
                THEN 'New York'
                ELSE 'Not Specified'
            END AS ZoneMarket, 
            LocationIsServicable
     FROM loc
     WHERE [Location Zone] NOT IN('MIC');
GO
