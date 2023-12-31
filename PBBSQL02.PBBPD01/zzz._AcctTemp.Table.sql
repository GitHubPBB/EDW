USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_AcctTemp]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_AcctTemp](
	[DimAccountId] [int] NOT NULL,
	[accountcode] [nvarchar](20) NOT NULL,
	[LocationId] [int] NOT NULL,
	[AccountName] [nvarchar](168) NOT NULL,
	[AccountActivationDate] [date] NULL,
	[AccountDeactivationDate] [date] NULL,
	[AccountStatus] [nvarchar](256) NOT NULL,
	[PhoneNumber] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[DimServiceLocationID] [int] NOT NULL,
	[FM AddressID] [int] NULL,
	[Omnia SrvItemLocationID] [int] NULL,
	[CycleDescription] [varchar](40) NOT NULL,
	[CycleNumber] [int] NOT NULL,
	[Location Zone] [varchar](8000) NULL,
	[Cabinet] [nvarchar](100) NULL,
	[Wirecenter Region] [varchar](40) NULL,
	[AutoPay] [nvarchar](max) NULL,
	[CPNIEmail] [nvarchar](100) NULL,
	[Telephone1] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Phone2] [nvarchar](50) NULL,
	[Phone3] [nvarchar](50) NULL,
	[PortalEmail] [varchar](255) NULL,
	[PortalUserExists] [varchar](1) NOT NULL,
	[Ebill_Flag] [varchar](1) NOT NULL,
	[Internal] [varchar](1) NOT NULL,
	[Courtesy] [varchar](1) NOT NULL,
	[MilitaryDiscount] [varchar](1) NOT NULL,
	[SeniorDiscount] [varchar](1) NOT NULL,
	[PointPause] [varchar](1) NOT NULL,
	[DiscPerc] [decimal](21, 6) NULL,
	[AccountGroupCode] [nvarchar](20) NOT NULL,
	[AccountType] [nvarchar](20) NOT NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NOT NULL,
	[ServiceLocationState] [varchar](50) NOT NULL,
	[ServiceLocationCity] [varchar](28) NOT NULL,
	[ServiceLocationPostalCode] [char](11) NOT NULL,
	[ServiceLocationTaxArea] [varchar](40) NOT NULL,
	[SalesRegion] [varchar](40) NOT NULL,
	[ProjectCode] [nvarchar](100) NOT NULL,
	[StreetName] [varchar](40) NOT NULL,
	[BillingAddressStreetLine1] [nvarchar](4000) NOT NULL,
	[BillingAddressStreetLine2] [nvarchar](4000) NOT NULL,
	[BillingAddressStreetLine3] [nvarchar](4000) NOT NULL,
	[BillingAddressStreetLine4] [nvarchar](4000) NOT NULL,
	[BillingAddressCity] [nvarchar](4000) NOT NULL,
	[BillingAddressState] [nvarchar](4000) NOT NULL,
	[BillingAddressPostalCode] [nvarchar](4000) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
