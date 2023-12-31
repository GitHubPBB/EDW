USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[pbb_DistributionCenter_20230208]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[pbb_DistributionCenter_20230208](
	[DistributionCenter] [nvarchar](200) NULL,
	[CusArea] [nvarchar](4000) NULL,
	[MDUName] [nvarchar](200) NULL,
	[pbb_LocationProjectCode] [nvarchar](100) NULL,
	[ServiceLocationFullAddress] [nvarchar](300) NULL,
	[chr_RegionIdName] [nvarchar](100) NULL,
	[ServiceLocationStatus] [nvarchar](256) NULL,
	[CusStatus] [nvarchar](4000) NULL,
	[cus_ContactName] [nvarchar](4000) NULL,
	[cus_ComplexName] [nvarchar](200) NULL,
	[cus_Rates] [nvarchar](max) NULL,
	[LocationIsServiceable] [nvarchar](50) NULL,
	[Fiber] [nvarchar](50) NULL,
	[FixedWireless] [nvarchar](50) NULL,
	[DefaultNetworkDelivery] [nvarchar](50) NULL,
	[ServiceableDate] [date] NULL,
	[LocationID] [int] NULL,
	[DimServiceLocationId] [int] NULL,
	[ActiveAccountFlag] [varchar](1) NOT NULL,
	[cus_HomesPassedorUnits] [int] NULL,
	[ttlAccounts] [int] NULL,
	[BulkDirectAccounts] [int] NULL,
	[TenantAccounts] [int] NULL,
	[MRC Avg Amt] [decimal](9, 2) NULL,
	[MRC Total Amt] [numeric](38, 7) NULL,
	[MRC Avg Bulk/Direct Amt] [decimal](9, 2) NULL,
	[MRC Total Bulk/Direct Amt] [numeric](38, 7) NULL,
	[MRC Avg Tenant Amt] [decimal](9, 2) NULL,
	[MRC Total Tenant Amt] [numeric](19, 4) NULL,
	[BulkOrDirect] [nvarchar](4000) NULL,
	[Cabinet] [nvarchar](100) NULL,
	[HostName] [varchar](302) NULL,
	[WireCenterRegion] [varchar](40) NULL,
	[cus_CabinetActivated] [bit] NULL,
	[cus_CabinetScheduled] [bit] NULL,
	[cus_MDUConstructionReadiness] [datetime] NULL,
	[cus_MDUDesignStarted] [datetime] NULL,
	[cus_MDUDesignComplete] [datetime] NULL,
	[cus_MDUConstructionStarted] [datetime] NULL,
	[cus_MDUConstructionComplete] [datetime] NULL,
	[cus_CabinetExpectedConstructionCompletion] [datetime] NULL,
	[cus_CabinetActualConstructionComplete] [datetime] NULL,
	[cus_CabinetActualServiceable] [datetime] NULL,
	[ROEAgreement] [nvarchar](4000) NULL,
	[CompetitiveStatus] [nvarchar](4000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
