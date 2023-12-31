USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[Performance_Subscriber_Data_Upload_Template_PHa]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Performance_Subscriber_Data_Upload_Template_PHa](
	[Cycle] [varchar](150) NULL,
	[Fund] [varchar](150) NULL,
	[SAC] [varchar](150) NULL,
	[Latitude] [varchar](150) NULL,
	[Longitude] [varchar](150) NULL,
	[Address] [varchar](150) NULL,
	[State] [varchar](150) NULL,
	[SpeedTier] [varchar](150) NULL,
	[NumberofUnits] [varchar](150) NULL,
	[CarrierLocationID] [varchar](150) NULL,
	[HUBBLocationID] [varchar](150) NULL,
	[SubscriberIDs] [varchar](150) NULL
) ON [PRIMARY]
GO
