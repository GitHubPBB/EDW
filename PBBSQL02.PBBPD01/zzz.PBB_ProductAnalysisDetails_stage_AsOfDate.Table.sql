USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_ProductAnalysisDetails_stage_AsOfDate]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_ProductAnalysisDetails_stage_AsOfDate](
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationID] [int] NOT NULL,
	[AccountCode] [nvarchar](20) NOT NULL,
	[AccountGroupCode] [nvarchar](20) NULL,
	[AccountType] [nvarchar](20) NULL,
	[AccountName] [nvarchar](168) NULL,
	[AccountActivationDate] [date] NULL,
	[AccountDeactivationDate] [date] NULL,
	[AccountStatus] [nvarchar](256) NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[Email] [nvarchar](100) NULL,
	[CPNIEmail] [nvarchar](100) NULL,
	[Telephone1] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Phone2] [nvarchar](50) NULL,
	[Phone3] [nvarchar](50) NULL,
	[PortalEmail] [varchar](255) NULL,
	[PortalUserExists] [varchar](1) NULL,
	[FirstServiceInstallDate] [date] NULL,
	[LastServiceDisconnectDate] [date] NULL,
	[ServiceAddress] [nvarchar](300) NULL,
	[ServiceStreetName] [varchar](40) NULL,
	[ServiceState] [varchar](50) NULL,
	[ServiceCity] [varchar](28) NULL,
	[ServicePostalCode] [char](11) NULL,
	[ServiceTaxArea] [varchar](40) NULL,
	[ServiceSalesRegion] [varchar](40) NULL,
	[ServiceProjectCode] [nvarchar](100) NULL,
	[BillingAddressLine1] [nvarchar](4000) NULL,
	[BillingAddressLine2] [nvarchar](4000) NULL,
	[BillingAddressLine3] [nvarchar](4000) NULL,
	[BillingAddressLine4] [nvarchar](4000) NULL,
	[BillingAddressCity] [nvarchar](4000) NULL,
	[BillingAddressState] [nvarchar](4000) NULL,
	[BillingAddressPostalCode] [nvarchar](4000) NULL,
	[CycleDescription] [varchar](40) NULL,
	[CycleNumber] [int] NULL,
	[Location Zone] [varchar](8000) NULL,
	[Cabinet] [nvarchar](100) NULL,
	[Wirecenter Region] [varchar](40) NULL,
	[FM AddressID] [int] NULL,
	[Omnia SrvItemLocationID] [int] NULL,
	[Internal] [varchar](1) NULL,
	[Courtesy] [varchar](1) NULL,
	[EmployeeFlag] [varchar](1) NOT NULL,
	[MilitaryDiscount] [varchar](1) NULL,
	[SeniorDiscount] [varchar](1) NULL,
	[PointPause] [varchar](1) NULL,
	[Ebill_Flag] [varchar](1) NULL,
	[HasData] [varchar](1) NOT NULL,
	[HasDataSvc] [varchar](1) NOT NULL,
	[DataCategory] [varchar](12) NULL,
	[DataSvc] [nvarchar](max) NULL,
	[DataServiceCharge] [decimal](12, 2) NULL,
	[DataServiceNetCharge] [decimal](12, 2) NULL,
	[HasSmartHome] [varchar](1) NOT NULL,
	[SmartHomeServiceCharge] [decimal](12, 2) NULL,
	[SmartHomeServiceNetCharge] [decimal](12, 2) NULL,
	[HasSmartHomePod] [varchar](1) NOT NULL,
	[SmartHomePodCharge] [decimal](12, 2) NULL,
	[SmartHomePodNetCharge] [decimal](12, 2) NULL,
	[HasPointGuard] [varchar](1) NOT NULL,
	[PointGuardCharge] [decimal](12, 2) NULL,
	[PointGuardNetCharge] [decimal](12, 2) NULL,
	[DataAddOnCharge] [decimal](12, 2) NULL,
	[DataAddOnNetCharge] [decimal](12, 2) NULL,
	[HasCable] [varchar](1) NOT NULL,
	[HasCableSvc] [varchar](1) NOT NULL,
	[CableCategory] [varchar](10) NULL,
	[CableSvc] [nvarchar](max) NULL,
	[CableServiceCharge] [decimal](12, 2) NULL,
	[CableServiceNetCharge] [decimal](12, 2) NULL,
	[HasHBO] [varchar](1) NOT NULL,
	[HBOServiceCharge] [decimal](12, 2) NULL,
	[HBONetCharge] [decimal](12, 2) NULL,
	[HasCinemax] [varchar](1) NOT NULL,
	[CinemaxServiceCharge] [decimal](12, 2) NULL,
	[CinemaxNetCharge] [decimal](12, 2) NULL,
	[HasShowtime] [varchar](1) NOT NULL,
	[ShowtimeServiceCharge] [decimal](12, 2) NULL,
	[ShowtimeNetCharge] [decimal](12, 2) NULL,
	[HasStarz] [varchar](1) NOT NULL,
	[StarzServiceCharge] [decimal](12, 2) NULL,
	[StarzNetCharge] [decimal](12, 2) NULL,
	[CableAddOnCharge] [decimal](12, 2) NULL,
	[CableAddOnNetCharge] [decimal](12, 2) NULL,
	[HasPhone] [varchar](1) NOT NULL,
	[HasPhoneSvc] [varchar](1) NOT NULL,
	[HasComplexPhoneSvc] [varchar](1) NOT NULL,
	[PhoneSvc] [nvarchar](max) NULL,
	[PhoneServiceCharge] [decimal](12, 2) NULL,
	[PhoneServiceNetCharge] [decimal](12, 2) NULL,
	[PhoneAddOnCharge] [decimal](12, 2) NULL,
	[PhoneAddOnNetCharge] [decimal](12, 2) NULL,
	[HasPromo] [varchar](1) NOT NULL,
	[PromoCharge] [decimal](12, 2) NULL,
	[PromoNetCharge] [decimal](12, 2) NULL,
	[HasTaxOrFee] [varchar](1) NOT NULL,
	[TaxFeeCharge] [decimal](12, 2) NULL,
	[TaxFeeNetCharge] [decimal](12, 2) NULL,
	[HasOther] [varchar](1) NOT NULL,
	[OtherCharge] [decimal](12, 2) NULL,
	[OtherNetCharge] [decimal](12, 2) NULL,
	[AutoPay] [nvarchar](max) NULL,
	[TotalCharge] [decimal](12, 2) NULL,
	[LocationId] [int] NULL,
	[DiscPerc] [decimal](21, 6) NULL,
	[DiscCount] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
