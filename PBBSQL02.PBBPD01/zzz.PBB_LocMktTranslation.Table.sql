USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_LocMktTranslation]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_LocMktTranslation](
	[Location Zone] [varchar](8000) NULL,
	[LocationZoneFriendly] [nvarchar](50) NULL,
	[Market] [nvarchar](50) NULL
) ON [PRIMARY]
GO
