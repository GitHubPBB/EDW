USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Atlas_FlatFile]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PBB_Atlas_FlatFile]
as
    begin
	   select distinct 
			[Omnia SrvItemLocationID] SrvLocationID
		    ,[House Number] HouseNumber
		    ,[House Suffix] HouseSuffix
		    ,PreDirectional
		    ,Street
		    ,[Street Suffix] StreetSuffix
		    ,PostDirectional
		    ,Apartment
		    ,Floor
		    ,room
		    ,city
		    ,[State Abbreviation] State
		    ,[Postal Code] PostalCode
		    ,[Postal Code Plus 4] PostalCodePlus4
		    ,Latitude
		    ,Longitude
		    ,[Wirecenter Region] SalesRegion
		    ,[Tax Area] TaxArea
		    ,case
			    when [Project Name] like '%PROJECT%'
			    then [Project Name] else ''
			end as ProjectName
		    ,LocationIsServicable
		    ,[Default Network Delivery] NetworkDelivery
		    ,FixedWireless
		    ,[account-location status]
	   from dimaddressdetails_pbb
	   where street <> ''
		    and [Location Zone] <> 'MIC'
	   order by SalesRegion
    end
GO
