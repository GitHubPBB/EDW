USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[michigan_details]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[michigan_details](
	[Account Code] [varchar](150) NULL,
	[Project Name] [varchar](150) NULL,
	[Cabinet] [varchar](150) NULL,
	[Market Type] [varchar](150) NULL,
	[Wirecenter Region] [varchar](150) NULL,
	[Serviceability] [varchar](150) NULL,
	[Serviceable Date] [varchar](150) NULL,
	[Created On] [varchar](150) NULL,
	[Omnia Location ID] [varchar](150) NULL,
	[Activation Date] [varchar](150) NULL,
	[Deactivation Date] [varchar](150) NULL,
	[Account Type] [varchar](150) NULL,
	[Account Name] [varchar](150) NULL,
	[Net] [varchar](150) NULL,
	[Service Address1] [varchar](150) NULL,
	[Service Address2] [varchar](150) NULL,
	[City] [varchar](150) NULL,
	[State] [varchar](150) NULL,
	[Postal Code] [varchar](150) NULL
) ON [PRIMARY]
GO
