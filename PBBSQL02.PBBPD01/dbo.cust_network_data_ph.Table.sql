USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[cust_network_data_ph]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cust_network_data_ph](
	[AccountNumber] [varchar](150) NULL,
	[accountstatus] [varchar](150) NULL,
	[AccountActivationDate] [varchar](150) NULL,
	[Market] [varchar](150) NULL,
	[AccountGroup] [varchar](150) NULL,
	[Customer_Name] [varchar](150) NULL,
	[phone] [varchar](150) NULL,
	[address] [varchar](150) NULL,
	[city] [varchar](150) NULL,
	[state] [varchar](150) NULL,
	[zip] [varchar](150) NULL,
	[latitude] [varchar](150) NULL,
	[longitude] [varchar](150) NULL,
	[NetworkID] [varchar](150) NULL,
	[Chassis] [varchar](150) NULL,
	[Card_Port_Slot] [varchar](150) NULL,
	[serialnumber] [varchar](150) NULL,
	[MACAddress] [varchar](150) NULL,
	[model] [varchar](150) NULL,
	[Class] [varchar](150) NULL,
	[Type] [varchar](150) NULL,
	[BPONType] [varchar](150) NULL,
	[CPE] [varchar](150) NULL,
	[Manufacturer] [varchar](150) NULL,
	[fibertype] [varchar](150) NULL,
	[Cabinet_Name] [varchar](150) NULL,
	[Project_Name] [varchar](150) NULL,
	[Service_Location] [varchar](150) NULL,
	[Plume_ID] [varchar](150) NULL,
	[Package_Name] [varchar](150) NULL,
	[Speed_Tier] [varchar](150) NULL,
	[DownLoad_Speed] [varchar](150) NULL,
	[Upload_Speed] [varchar](150) NULL
) ON [PRIMARY]
GO
