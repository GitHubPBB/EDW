USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_oldedgeout]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_oldedgeout](
	[ID] [nvarchar](100) NULL,
	[Project Name] [nvarchar](100) NULL,
	[Cabinet] [nvarchar](100) NULL,
	[Wirecenter Region] [nvarchar](100) NULL,
	[MarketType] [nvarchar](100) NULL,
	[FundType] [nvarchar](100) NULL,
	[FundTypeID] [nvarchar](100) NULL,
	[Omnia SrvItemLocationID] [nvarchar](100) NULL,
	[Full Address] [nvarchar](400) NULL,
	[AddressNoPostal] [nvarchar](400) NULL,
	[ServiceAddress1] [nvarchar](100) NULL,
	[ServiceAddress2] [nvarchar](100) NULL,
	[City] [nvarchar](100) NULL,
	[State Abbreviation] [nvarchar](100) NULL,
	[Postal Code] [nvarchar](100) NULL,
	[CreatedOn] [nvarchar](100) NULL,
	[ServiceLocationCreatedBy] [nvarchar](100) NULL,
	[Serviceability] [nvarchar](100) NULL,
	[Serviceable Date] [nvarchar](100) NULL,
	[AccountLocationStatus] [nvarchar](100) NULL,
	[ActiveCount] [nvarchar](100) NULL,
	[Account-Service Activation Date] [nvarchar](100) NULL,
	[Account-Service Deactivation Date] [nvarchar](100) NULL,
	[AccountType] [nvarchar](100) NULL,
	[accountgroup] [nvarchar](100) NULL,
	[AccountCode] [nvarchar](100) NULL,
	[AccountName] [nvarchar](100) NULL,
	[BillingYearYYYY] [nvarchar](100) NULL,
	[BillingMonthMMM] [nvarchar](100) NULL,
	[ChargeAmount] [nvarchar](100) NULL,
	[PromotionAmount] [nvarchar](100) NULL,
	[DiscountAmount] [nvarchar](100) NULL,
	[Net] [nvarchar](100) NULL
) ON [PRIMARY]
GO
