USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimPromoStatus_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PBB_Populate_DimPromoStatus_pbb]
AS
    begin

	   set nocount on

	   truncate table DimPromoStatus_pbb

	   insert into DimPromoStatus_pbb
			select *
			from PBB_PromotionStatus
    end
GO
