USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_Snapshot_ServiceablePassings]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_Snapshot_ServiceablePassings](
	[RunDate] [nvarchar](4000) NULL,
	[LocationID] [int] NULL,
	[AddressNoPostal] [varchar](233) NULL,
	[Project Name] [nvarchar](100) NULL,
	[Cabinet] [nvarchar](100) NULL,
	[FundType] [varchar](max) NULL,
	[FundTypeId] [varchar](max) NULL,
	[Wirecenter Region] [varchar](40) NULL,
	[City] [varchar](28) NULL,
	[State] [varchar](50) NULL,
	[Tax Area] [varchar](40) NULL,
	[ZoneMarket] [varchar](13) NOT NULL,
	[LocationIsServicable] [nvarchar](50) NULL,
	[ServiceableDate] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
