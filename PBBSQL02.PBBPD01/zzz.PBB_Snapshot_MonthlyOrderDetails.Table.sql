USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_Snapshot_MonthlyOrderDetails]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_Snapshot_MonthlyOrderDetails](
	[Billing_Review_Date] [datetime2](7) NULL,
	[Sales_Order_Type] [nvarchar](max) NULL,
	[Account_Group] [nvarchar](max) NULL,
	[Account_Code] [int] NULL,
	[Customer_Name] [nvarchar](50) NULL,
	[Service_Location_Full_Address] [nvarchar](max) NULL,
	[Account_Market] [nvarchar](max) NULL,
	[Sales_Order_Number] [nvarchar](max) NULL,
	[Sales_Order_Name] [nvarchar](max) NULL,
	[column10] [nvarchar](max) NULL,
	[Total_MRC] [money] NULL,
	[Sales_Order_Total_Amount] [money] NULL,
	[Sales_Order_Status] [nvarchar](max) NULL,
	[Sales_Order_Status_Reason] [nvarchar](max) NULL,
	[Sales_Order_Fulfillment_Status] [nvarchar](max) NULL,
	[Completion_Date] [datetime2](7) NULL,
	[Disconnect_Type] [nvarchar](max) NULL,
	[Disconnect_Reason] [nvarchar](max) NULL,
	[Sales_Order_Owner] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
