USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Rebuild_PBB_FactCustomerBundleType_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/

create procedure [dbo].[PBB_Rebuild_PBB_FactCustomerBundleType_pbb]
as
    begin

	   truncate table dbo.FactCustomerBundleType_pbb

	   declare @EffectiveDate date = '5/1/2021'

	   while @EffectiveDate < Convert(date,getdate())

		  begin

			 exec dbo.PBB_Populate_FactCustomerBundleType_pbb 
				 @EffectiveDate

			 set @EffectiveDate = dateadd(day,1,@EffectiveDate)
		  end
    end
GO
