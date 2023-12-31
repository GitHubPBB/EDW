USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[M33_Passings_Smarty_Results_pride]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[M33_Passings_Smarty_Results_pride](
	[Location Zone] [varchar](150) NULL,
	[Project Name] [varchar](150) NULL,
	[Cabinet] [varchar](150) NULL,
	[Wirecenter Region] [varchar](150) NULL,
	[Omnia Location ID] [varchar](150) NULL,
	[Name] [varchar](150) NULL,
	[Street Address1] [varchar](150) NULL,
	[Street Address2] [varchar](150) NULL,
	[City] [varchar](150) NULL,
	[State Abbreviation] [varchar](150) NULL,
	[Postal Code] [varchar](150) NULL,
	[Premise Type] [varchar](150) NULL,
	[Marketable] [varchar](150) NULL,
	[Location Is Servicable] [varchar](150) NULL,
	[Account Location Status] [varchar](150) NULL
) ON [PRIMARY]
GO
