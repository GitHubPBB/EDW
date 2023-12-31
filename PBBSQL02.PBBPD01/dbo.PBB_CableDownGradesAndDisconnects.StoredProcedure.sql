USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [dbo].[PBB_CableDownGradesAndDisconnects]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PBB_CableDownGradesAndDisconnects](
			  @fromDate date = '11/22/2021'
			 ,@toDate   date = '11/28/2021'
										)
AS
    begin

	   select @fromDate as [DimDateId-from]
		    ,@toDate as [DimDateId-to]
		    ,a.AccountCode
		    ,coalesce([from].[DimAccountId],[to].[DimAccountId]) as [DimAccountId]
		    ,coalesce([from].[DimServiceLocationId],[to].[DimServicelocationId]) as DimServiceLocationId
		    ,isnull([from].PBB_BundleType,'None') as [From BundleType]
		    ,isnull([to].PBB_BundleType,'None') as [To BundleType]
		    ,bt.TransitionType
	   from [dbo].[PBB_GetLocationAccountBundleType](@fromDate) [from]
		   full outer join [dbo].[PBB_GetLocationAccountBundleType](@toDate) [to] on [to].[DimAccountId] = [from].[DimAccountID]
																	  and [to].[DimServiceLocationId] = [from].[DimServiceLocationId]
		   inner join [dbo].[PBB_BundleTransition] bt on bt.BundleType = [from].PBB_BundleType
											    and bt.ToBundleType = [to].PBB_BundleType
		   inner join [dbo].[DimAccount] a on a.DimAccountId = coalesce([from].[DimAccountId],[to].[DimAccountId])
	   where [from].[PBB_BundleType] in
								(
								 'Double Play-Phone/Cable'
								,'Double Play-Internet/Cable'
								,'Triple Play-Internet/Phone/Cable'
								,'Cable Only'
								)
		    and ([to].[PBB_BundleType] in
								   (
								    'Phone Only'
								   ,'Double Play-Internet/Phone'
								   ,'Internet Only'
								   ,'Other'
								   ,'None'
								   )
	   or [to].[PBB_BundleType] is null)
	   order by bt.TransitionType
			 ,bt.BundleType;

    end
GO
