USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_ServiceablePassingDetailReport]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PBB_ServiceablePassingDetailReport]
AS
    BEGIN

	DECLARE @Sql nvarchar(max),
        @Sqlcol  nvarchar(max),
        @ISNULLSqlcol nvarchar(max),
		@MaxRunDate nvarchar(max), 
		@LastRunDate nvarchar(max)

SELECT  @Sqlcol=STUFF((SELECT    ', '+QUOTENAME(mon) 
                FROM 			
				(select format(dateadd(month, num, '2022-04-01'),'yyyy-MM') as mon,
					row_number() over (order by dateadd(month, num, '2022-04-01') desc) Ord
					from (select row_number() over (partition by NULL order by (select NULL)) as num
					from Information_Schema.Columns c) n 
				 where dateadd(month, num, '2022-04-01') < getdate()) col 
				 order by mon desc
				FOR XML PATH ('')),1,1,'');

SELECT  @ISNULLSqlcol=STUFF((SELECT DISTINCT  ', '+'ISNULL(SUM('+QUOTENAME(mon) +'),''0'') AS '+QUOTENAME(mon)
                FROM (select format(dateadd(month, num, '2022-04-01'),'yyyy-MM') as mon,
					row_number() over (order by dateadd(month, num, '2022-04-01') desc) Ord
					from (select row_number() over (partition by NULL order by (select NULL)) as num
					from Information_Schema.Columns c) n 
				 where dateadd(month, num, '2022-04-01') < getdate()) col   
				 FOR XML PATH ('')),1,1,'');

with cyclecount as (select RunDate, row_number() over (order by rundate desc) Ord
					 from
					 (select distinct RunDate from PBB_Snapshot_ServiceablePassings) c)

select @LastRunDate = (select RunDate from cyclecount where Ord = 2);

set @MaxRunDate = (select max(rundate) RunDate from PBB_Snapshot_ServiceablePassings);

SET @Sql= 'select isnull(TM.LocationID,LM.LocationID) LocationID, 
  isnull(TM.AddressNoPostal, LM.AddressNoPostal) AddressNoPostal,
  isnull(TM.[Project Name], LM.[Project Name]) Project,
  isnull(TM.Cabinet, LM.Cabinet) Cabinet,
  isnull(TM.FundType, LM.FundType) AddressSubsidiary,
  isnull(TM.FundTypeId, LM.FundTypeId) AddressSubsidiaryID,
  isnull(TM.[Wirecenter Region], LM.[Wirecenter Region]) SalesRegion,
  isnull(TM.City, LM.City) City,
  isnull(TM.State, LM.State) State,
  isnull(TM.[Tax Area], LM.[Tax Area]) TaxArea,
  isnull(TM.ZoneMarket, LM.ZoneMarket) Market,
  isnull(TM.LocationIsServicable, LM.LocationIsServicable) Serviceable,
  isnull(TM.ServiceableDate, LM.ServiceableDate) ServiceableDate,
  '+@Sqlcol+',
  case when ' +QUOTENAME(@MaxRunDate)+' = '+QUOTENAME(@LastRunDate)+' and '+QUOTENAME(@MaxRunDate)+' = 1 then ''Existing Serviceable, No Change''
	when '+QUOTENAME(@MaxRunDate)+' = '+QUOTENAME(@LastRunDate)+' and '+QUOTENAME(@MaxRunDate)+' = 0 then ''Existing NonServiceable, No Change''
	when isnull('+QUOTENAME(@MaxRunDate)+',0) = 1 and isnull('+QUOTENAME(@LastRunDate)+',0) = 0 then ''Made Serviceable or New''
	when isnull('+QUOTENAME(@MaxRunDate)+',0) = 0 and isnull('+QUOTENAME(@LastRunDate)+',0) = 1 then ''Made NonServiceable''
	when TM.LocationID is null and LM.LocationID is not null then ''Deleted''
	when '+QUOTENAME(@MaxRunDate)+' = 0 and '+QUOTENAME(@LastRunDate)+' is null then ''New NonServiceable''
	end as ChangeType,
  case when '+QUOTENAME(@MaxRunDate)+' = '+QUOTENAME(@LastRunDate)+' and '+QUOTENAME(@MaxRunDate)+' = 1 then 0
	when '+QUOTENAME(@MaxRunDate)+' = '+QUOTENAME(@LastRunDate)+' and '+QUOTENAME(@MaxRunDate)+' = 0 then 0
	when '+QUOTENAME(@MaxRunDate)+' = 1 and isnull('+QUOTENAME(@LastRunDate)+',0) = 0 then 1
	when '+QUOTENAME(@MaxRunDate)+' = 0 and '+QUOTENAME(@LastRunDate)+' = 1 then -1
	when '+QUOTENAME(@MaxRunDate)+' = 0 and '+QUOTENAME(@LastRunDate)+' is null then 0
	when '+QUOTENAME(@MaxRunDate)+' = '+QUOTENAME(@LastRunDate)+' and '+QUOTENAME(@MaxRunDate)+' = 1 then 0
	when '+QUOTENAME(@MaxRunDate)+' = '+QUOTENAME(@LastRunDate)+' and '+QUOTENAME(@MaxRunDate)+' = 0 then 0
	when '+QUOTENAME(@MaxRunDate)+' = 1 and '+QUOTENAME(@LastRunDate)+' = 0 then 1
	when '+QUOTENAME(@MaxRunDate)+' = 0 and '+QUOTENAME(@LastRunDate)+' = 1 then 1
	when TM.LocationID is null and LM.LocationIsServicable = ''Yes'' then -1
	when TM.LocationID is null and LM.LocationIsServicable = ''No'' then 0
	when '+QUOTENAME(@MaxRunDate)+' = 0 and '+QUOTENAME(@LastRunDate)+' is null then 0
	end as Net
  from
	  (select SP.*,'+@Sqlcol+'
	  from PBB_Snapshot_ServiceablePassings SP
			 JOIN (select max(rundate) RunDate from PBB_Snapshot_ServiceablePassings) RD on SP.RunDate = RD.RunDate
			 LEFT JOIN 
				(select * from
				(select LocationID,
				 Case when isnull(LocationIsServicable,''No'') = ''Yes'' then 1 else 0 end as SvcCount, rundate
				 from PBB_Snapshot_ServiceablePassings 
				 ) x
				 pivot (sum(SvcCount) for rundate in ('+@Sqlcol+')) as pvt) serv on SP.LocationID = serv.LocationID) TM
		FULL OUTER JOIN 
		(select * from PBB_Snapshot_ServiceablePassings LASTSP where LASTSP.RunDate = '''+@LastRunDate+''') LM on TM.LocationID = LM.LocationID'

Print @Sql
EXEC (@Sql)

END;
GO
