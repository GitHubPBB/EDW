USE [PBBPDW01]
GO
/****** Object:  Table [dbo].[cust_network_data]    Script Date: 12/5/2023 5:09:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cust_network_data](
	[AccountNumber] [nvarchar](20) NULL,
	[accountstatus] [nvarchar](40) NULL,
	[AccountActivationDate] [smalldatetime] NULL,
	[Market] [varchar](22) NULL,
	[AccountGroup] [char](6) NULL,
	[Customer_Name] [nvarchar](160) NULL,
	[phone] [nvarchar](50) NULL,
	[address] [varchar](8000) NULL,
	[city] [varchar](28) NULL,
	[STATE] [varchar](6) NULL,
	[zip] [varchar](11) NULL,
	[latitude] [varchar](11) NULL,
	[longitude] [varchar](11) NULL,
	[NetworkID] [nvarchar](50) NULL,
	[Chassis] [nvarchar](50) NULL,
	[Card_Port_Slot] [nvarchar](50) NULL,
	[serialnumber] [nvarchar](50) NULL,
	[MACAddress] [nvarchar](110) NULL,
	[model] [nvarchar](300) NULL,
	[fibertype] [varchar](13) NOT NULL,
	[Cabinet_Name] [nvarchar](100) NULL,
	[Project_Name] [nvarchar](100) NULL,
	[Service_Location] [nvarchar](250) NULL,
	[Plume_ID] [nvarchar](50) NULL,
	[Package_Name] [varchar](255) NULL,
	[Speed_Tier] [nvarchar](50) NULL,
	[DownLoad_Speed] [nvarchar](50) NULL,
	[Upload_Speed] [nvarchar](50) NULL
) ON [PRIMARY]
GO
