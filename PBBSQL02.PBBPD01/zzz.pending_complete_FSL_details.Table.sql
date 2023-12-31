USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[pending_complete_FSL_details]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[pending_complete_FSL_details](
	[Account Number] [varchar](150) NULL,
	[Appointment Number] [varchar](150) NULL,
	[Customer Name] [varchar](150) NULL,
	[Subject] [varchar](150) NULL,
	[Created Date] [varchar](150) NULL,
	[SA Completed Date] [varchar](150) NULL,
	[City] [varchar](150) NULL,
	[Address] [varchar](150) NULL,
	[Street] [varchar](150) NULL,
	[Order Number] [varchar](150) NULL,
	[Service Territory  Name] [varchar](150) NULL,
	[Status] [varchar](150) NULL
) ON [PRIMARY]
GO
