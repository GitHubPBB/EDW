USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_Populate_DimAddressDetails_pbb]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PBB_Populate_DimAddressDetails_pbb]
AS
    begin

	   set nocount on

	   truncate table DimAddressDetails_pbb

	   insert into DimAddressDetails_pbb
			select *
			from DimAddressDetails
    end
GO
