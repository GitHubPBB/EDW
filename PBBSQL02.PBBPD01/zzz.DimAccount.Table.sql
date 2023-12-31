USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimAccount]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimAccount](
	[DimAccountId] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [nvarchar](400) NOT NULL,
	[AccountActivationDate] [date] NULL,
	[AccountDeactivationDate] [date] NULL,
	[AccountCode] [nvarchar](20) NOT NULL,
	[AccountName] [nvarchar](168) NOT NULL,
	[AccountStatusCode] [nvarchar](1) NOT NULL,
	[AccountStatus] [nvarchar](256) NOT NULL,
	[CreditLimit] [money] NOT NULL,
	[AccountPhoneNumber] [nvarchar](50) NOT NULL,
	[AccountEMailAddress] [nvarchar](100) NOT NULL,
	[AccountSocialSecurityNumber] [nvarchar](100) NOT NULL,
	[AccountSSNLast4Digits] [nvarchar](4) NOT NULL,
	[AccountFederalTaxID] [nvarchar](100) NOT NULL,
	[BillingAddressAttention] [nvarchar](50) NOT NULL,
	[AccountBirthDate] [date] NULL,
	[BillingAddressStreetLine1] [nvarchar](4000) NOT NULL,
	[BillingAddressStreetLine2] [nvarchar](4000) NOT NULL,
	[BillingAddressStreetLine3] [nvarchar](4000) NOT NULL,
	[BillingAddressStreetLine4] [nvarchar](4000) NOT NULL,
	[BillingAddressCity] [nvarchar](4000) NOT NULL,
	[BillingAddressState] [nvarchar](4000) NOT NULL,
	[BillingAddressStateAbbreviation] [nvarchar](6) NOT NULL,
	[BillingAddressCountry] [nvarchar](4000) NOT NULL,
	[BillingAddressPostalCode] [nvarchar](4000) NOT NULL,
	[BillingAddressPhone] [nvarchar](50) NOT NULL,
	[BillingAddressPOBox] [nvarchar](25) NOT NULL,
	[BillingAddressHouseNumber] [nvarchar](10) NOT NULL,
	[BillingAddressStreetName] [nvarchar](100) NOT NULL,
	[BillingAddressApartmentNumber] [nvarchar](75) NOT NULL,
	[InvoiceFormat] [nvarchar](256) NOT NULL,
	[PrintGroup] [nvarchar](40) NOT NULL,
	[CpniPassword] [nvarchar](4000) NOT NULL,
	[CpniPasswordDate] [date] NULL,
	[CpniOptOut] [nvarchar](1) NOT NULL,
	[CpniOptOutDate] [date] NULL,
	[CpniOptIn] [nvarchar](1) NOT NULL,
	[CpniOptInDate] [date] NULL,
	[AccountPreferredContactMethod] [nvarchar](256) NOT NULL,
	[AccountAllowEmail] [nvarchar](256) NOT NULL,
	[AccountAllowBulkEmail] [nvarchar](256) NOT NULL,
	[AccountAllowPhone] [nvarchar](256) NOT NULL,
	[AccountAllowFax] [nvarchar](256) NOT NULL,
	[AccountAllowMail] [nvarchar](256) NOT NULL,
	[AccountAllowText] [nvarchar](256) NOT NULL,
	[AccountOwner] [nvarchar](200) NOT NULL,
	[AccountLastDateIncludedInCampaign] [date] NULL,
	[ArAccountRemarks] [varchar](4000) NOT NULL,
	[AccountDueDateExtDays] [int] NOT NULL,
	[AccountPromiseToPayExempt] [nvarchar](50) NOT NULL,
	[AccountNoticeExempt] [nvarchar](50) NOT NULL,
	[AccountLateFeeExempt] [nvarchar](50) NOT NULL,
	[AccountCreditRatingExempt] [nvarchar](50) NOT NULL,
	[AccountCreditEventsExempt] [nvarchar](50) NOT NULL,
	[AccountNonPayDisconnectExempt] [nvarchar](50) NOT NULL,
	[AccountACHBankName] [varchar](40) NOT NULL,
	[AccountACHBankRoutingNumber] [varchar](9) NOT NULL,
	[AccountACHLast4Digits] [varchar](10) NOT NULL,
	[AccountACHEndDate] [date] NULL,
	[AccountACHStartDate] [date] NULL,
	[AccountACHDistribution] [varchar](40) NOT NULL,
	[AccountACHStatus] [nvarchar](10) NOT NULL,
	[AccountACHAddedViaWeb] [nvarchar](10) NOT NULL,
	[AccountSetName] [varchar](1000) NOT NULL,
	[AccountAgent] [nvarchar](40) NOT NULL,
	[AccountLastInvoiceDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[DimAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
