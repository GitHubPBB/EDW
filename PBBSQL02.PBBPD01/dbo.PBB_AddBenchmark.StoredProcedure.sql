USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_AddBenchmark]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PBB_AddBenchmark](
			  @process varchar(100)
			 ,@started datetime
			 ,@ended   datetime
						   )
as
    begin

	   set nocount on

	   insert INTO dbo.PBB_BenchmarkLog
								([process]
								,[started]
								,[ended]
								)
	   values
	   (
			@process
		    ,@started
		    ,@ended
	   )

    end
GO
