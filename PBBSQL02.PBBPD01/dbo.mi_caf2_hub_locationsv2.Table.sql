USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[mi_caf2_hub_locationsv2]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mi_caf2_hub_locationsv2](
	[Study_Area_Code] [varchar](150) NULL,
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
	[Date_of_Deployment] [varchar](150) NULL,
	[DownloadUploadSpeedTier] [varchar](150) NULL,
	[Address] [varchar](150) NULL,
	[City] [varchar](150) NULL,
	[State] [varchar](150) NULL,
	[Zip_Code] [varchar](150) NULL,
	[NumberofUnits] [varchar](150) NULL,
	[CarrierLocationID] [varchar](150) NULL,
	[Technology] [varchar](150) NULL,
	[Other_Technology] [varchar](150) NULL,
	[Latency] [varchar](150) NULL
) ON [PRIMARY]
GO
