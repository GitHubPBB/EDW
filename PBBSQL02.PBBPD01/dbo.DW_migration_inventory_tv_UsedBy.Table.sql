USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[DW_migration_inventory_tv_UsedBy]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DW_migration_inventory_tv_UsedBy](
	[tv_ObjectId] [varchar](20) NULL,
	[UsedIn_pf_ObjectId] [varchar](20) NULL
) ON [PRIMARY]
GO
