USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimFMEquipment]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimFMEquipment](
	[DimFMEquipmentId] [int] IDENTITY(1,1) NOT NULL,
	[EQUIPMENT_Id] [int] NOT NULL,
	[EquipmentLCE] [nvarchar](100) NOT NULL,
	[EquipmentType] [nvarchar](50) NOT NULL,
	[EquipmentStatus] [nvarchar](50) NOT NULL,
	[EquipmentComment] [nvarchar](255) NOT NULL,
	[EquipmentCutStatus] [nvarchar](50) NOT NULL,
	[EquipmentAssignNum] [nvarchar](10) NOT NULL,
	[EquipmentOldAssignNum] [nvarchar](10) NOT NULL,
	[EquipmentCardAssignment] [nvarchar](50) NOT NULL,
	[EquipmentFormattedAssignNum] [nvarchar](8) NOT NULL,
	[EquipmentMfgId] [nvarchar](50) NOT NULL,
	[EquipmentTerminalAddress] [nvarchar](100) NOT NULL,
	[EquipmentCustomerOwned] [nvarchar](1) NOT NULL,
	[EquipmentCreditLimit] [nvarchar](40) NOT NULL,
	[EquipmentLocation] [nvarchar](100) NOT NULL,
	[EquipmentIP] [nvarchar](60) NOT NULL,
	[EquipmentHostIdentifier] [nvarchar](100) NOT NULL,
	[EquipmentCableCardId] [nvarchar](100) NOT NULL,
	[EquipmentMTAMAC] [nvarchar](60) NOT NULL,
	[EquipmentInstallDate] [datetime] NULL,
	[EquipmentSecurityData] [nvarchar](100) NOT NULL,
	[EquipmentBatteryInstallDate] [datetime] NULL,
	[EquipmentPurchaseDate] [datetime] NULL,
	[EquipmentItemProtected] [bit] NOT NULL,
	[EquipmentWireCenterCode] [nvarchar](50) NOT NULL,
	[EquipmentWireCenterName] [nvarchar](50) NOT NULL,
	[EquipmentEquipmentType] [nvarchar](50) NOT NULL,
	[EquipmentDeviceGroup] [nvarchar](50) NOT NULL,
	[EquipmentHeadend] [varchar](40) NOT NULL,
	[EquipmentHeadendCode] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimFMEquipmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[EQUIPMENT_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
