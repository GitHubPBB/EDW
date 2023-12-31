USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[VB_pcode_migrated_Omnia_Customer_Equipment_ph]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VB_pcode_migrated_Omnia_Customer_Equipment_ph](
	[Omnia_Account_Number] [varchar](175) NULL,
	[CustomerID_OLD_VB] [varchar](175) NULL,
	[Name] [varchar](175) NULL,
	[EquipmentID] [varchar](175) NULL,
	[EquipmentType] [varchar](175) NULL,
	[DeviceType] [varchar](175) NULL,
	[MAC] [varchar](175) NULL,
	[IP] [varchar](175) NULL,
	[Omnia_Status] [varchar](175) NULL
) ON [PRIMARY]
GO
