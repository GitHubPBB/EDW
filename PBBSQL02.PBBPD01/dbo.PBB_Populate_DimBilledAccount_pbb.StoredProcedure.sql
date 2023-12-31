USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimBilledAccount_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PBB_Populate_DimBilledAccount_pbb](
			  @Year  int = NULL
			 ,@Month int = NULL
											   )
AS
    begin

	   if @Year is NULL
		  begin
			 set @year = datepart(Year,GetDate())
			 set @month = datepart(Month,GetDate())
		  end

	   delete from [OMNIA_EPBB_P_PBB_DW].[dbo].[DimBilledAccount_pbb]
	   where BillingYearMonth = (@Year * 100) + @Month

	   execute [PBBSQL01].[PBB_ClientWorkspace].[dbo].[PBB_Populate_DimBilledAccount_pbb] 
			 @Year
			,@Month

	   insert into [dbo].[DimBilledAccount_pbb]
			select *
			from [PBBSQL01].[PBB_ClientWorkspace].[dbo].[DimBilledAccount_pbb]

    end
GO
