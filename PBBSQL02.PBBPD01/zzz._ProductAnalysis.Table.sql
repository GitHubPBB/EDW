USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_ProductAnalysis]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_ProductAnalysis](
	[DimAccountId] [int] NOT NULL,
	[DimServiceLocationID] [int] NOT NULL,
	[AccountGroupCode] [nvarchar](20) NOT NULL,
	[AccountType] [nvarchar](20) NOT NULL,
	[AccountCode] [nvarchar](20) NOT NULL,
	[AccountName] [nvarchar](168) NOT NULL,
	[AccountActivationDate] [date] NULL,
	[AccountDeactivationDate] [date] NULL,
	[AccountStatus] [nvarchar](256) NOT NULL,
	[PhoneNumber] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[CPNIEmail] [nvarchar](100) NULL,
	[Telephone1] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Phone2] [nvarchar](50) NULL,
	[Phone3] [nvarchar](50) NULL,
	[PortalEmail] [varchar](255) NULL,
	[PortalUserExists] [varchar](1) NOT NULL,
	[FirstServiceInstallDate] [date] NULL,
	[LastServiceDisconnectDate] [date] NULL,
	[ServiceAddress] [nvarchar](300) NOT NULL,
	[ServiceStreetName] [varchar](40) NOT NULL,
	[ServiceState] [varchar](50) NOT NULL,
	[ServiceCity] [varchar](28) NOT NULL,
	[ServicePostalCode] [char](11) NOT NULL,
	[ServiceTaxArea] [varchar](40) NOT NULL,
	[ServiceSalesRegion] [varchar](40) NOT NULL,
	[ServiceProjectCode] [nvarchar](100) NOT NULL,
	[BillingAddressLine1] [nvarchar](4000) NOT NULL,
	[BillingAddressLine2] [nvarchar](4000) NOT NULL,
	[BillingAddressLine3] [nvarchar](4000) NOT NULL,
	[BillingAddressLine4] [nvarchar](4000) NOT NULL,
	[BillingAddressCity] [nvarchar](4000) NOT NULL,
	[BillingAddressState] [nvarchar](4000) NOT NULL,
	[BillingAddressPostalCode] [nvarchar](4000) NOT NULL,
	[CycleDescription] [varchar](40) NOT NULL,
	[CycleNumber] [int] NOT NULL,
	[Location Zone] [varchar](8000) NULL,
	[Cabinet] [nvarchar](100) NULL,
	[Wirecenter Region] [varchar](40) NULL,
	[FM AddressID] [int] NULL,
	[Omnia SrvItemLocationID] [int] NULL,
	[Internal] [varchar](1) NOT NULL,
	[Courtesy] [varchar](1) NOT NULL,
	[EmployeeFlag] [varchar](1) NOT NULL,
	[MilitaryDiscount] [varchar](1) NOT NULL,
	[SeniorDiscount] [varchar](1) NOT NULL,
	[PointPause] [varchar](1) NOT NULL,
	[Ebill_Flag] [varchar](1) NOT NULL,
	[HasPackage] [varchar](1) NOT NULL,
	[Package] [nvarchar](max) NOT NULL,
	[TotalPackageCharge] [money] NOT NULL,
	[UnallocatedPackageCharge] [decimal](38, 6) NULL,
	[HasData] [varchar](1) NOT NULL,
	[HasDataSvc] [varchar](1) NOT NULL,
	[DataCategory] [varchar](12) NOT NULL,
	[DataSvc] [nvarchar](max) NOT NULL,
	[DataServiceCharge] [decimal](38, 6) NULL,
	[DataServiceNetCharge] [decimal](38, 6) NULL,
	[HasSmartHome] [varchar](1) NOT NULL,
	[SmartHomeServiceCharge] [decimal](38, 6) NULL,
	[SmartHomeServiceNetCharge] [decimal](38, 6) NULL,
	[HasSmartHomePod] [varchar](1) NOT NULL,
	[SmartHomePodCharge] [money] NULL,
	[SmartHomePodNetCharge] [money] NULL,
	[HasPointGuard] [varchar](1) NOT NULL,
	[PointGuardCharge] [money] NULL,
	[PointGuardNetCharge] [money] NULL,
	[DataAddOnCharge] [money] NULL,
	[DataAddOnNetCharge] [money] NULL,
	[HasCable] [varchar](1) NOT NULL,
	[HasCableSvc] [varchar](1) NOT NULL,
	[CableCategory] [varchar](10) NOT NULL,
	[CableSvc] [nvarchar](max) NOT NULL,
	[CableServiceCharge] [money] NULL,
	[CableServiceNetCharge] [money] NULL,
	[HasHBO] [varchar](1) NOT NULL,
	[HBOServiceCharge] [money] NULL,
	[HBONetCharge] [money] NULL,
	[HasCinemax] [varchar](1) NOT NULL,
	[CinemaxServiceCharge] [money] NULL,
	[CinemaxNetCharge] [money] NULL,
	[HasShowtime] [varchar](1) NOT NULL,
	[ShowtimeServiceCharge] [money] NULL,
	[ShowtimeNetCharge] [money] NULL,
	[HasStarz] [varchar](1) NOT NULL,
	[StarzServiceCharge] [money] NULL,
	[StarzNetCharge] [money] NULL,
	[CableAddOnCharge] [money] NULL,
	[CableAddOnNetCharge] [money] NULL,
	[HasPhone] [varchar](1) NOT NULL,
	[HasPhoneSvc] [varchar](1) NOT NULL,
	[HasComplexPhoneSvc] [varchar](1) NOT NULL,
	[PhoneSvc] [nvarchar](max) NOT NULL,
	[PhoneServiceCharge] [decimal](38, 6) NULL,
	[PhoneServiceNetCharge] [decimal](38, 6) NULL,
	[PhoneAddOnCharge] [decimal](38, 6) NULL,
	[PhoneAddOnNetCharge] [decimal](38, 6) NULL,
	[HasPromo] [varchar](1) NOT NULL,
	[PromoCharge] [decimal](38, 6) NULL,
	[PromoNetCharge] [decimal](38, 6) NULL,
	[HasTaxOrFee] [varchar](1) NOT NULL,
	[TaxFeeCharge] [money] NULL,
	[TaxFeeNetCharge] [money] NULL,
	[HasOther] [varchar](1) NOT NULL,
	[OtherCharge] [money] NULL,
	[OtherNetCharge] [money] NULL,
	[AutoPay] [nvarchar](max) NULL,
	[TotalCharge] [decimal](38, 6) NULL,
	[PackageAllocation] [varchar](19) NULL,
	[EffectiveStartDate] [date] NULL,
	[EffectiveEndDate] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
