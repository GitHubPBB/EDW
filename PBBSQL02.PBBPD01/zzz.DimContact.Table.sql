USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimContact]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimContact](
	[DimContactId] [int] IDENTITY(1,1) NOT NULL,
	[ContactId] [nvarchar](400) NOT NULL,
	[ContactLastName] [nvarchar](75) NOT NULL,
	[ContactFirstName] [nvarchar](50) NOT NULL,
	[ContactMiddleName] [nvarchar](50) NOT NULL,
	[ContactPrefix] [char](4) NOT NULL,
	[ContactSuffix] [nvarchar](10) NOT NULL,
	[ContactBirthDate] [date] NULL,
	[ContactBusinessPhone] [nvarchar](50) NOT NULL,
	[ContactHomePhone] [nvarchar](50) NOT NULL,
	[ContactEmail] [nvarchar](100) NOT NULL,
	[ContactApartment] [varchar](75) NOT NULL,
	[ContactPostalCode] [nvarchar](100) NOT NULL,
	[ContactCorporation] [varchar](40) NOT NULL,
	[ContactFederalTaxID] [char](9) NOT NULL,
	[ContactClass] [nvarchar](100) NOT NULL,
	[ContactCity] [nvarchar](100) NOT NULL,
	[ContactStateAbbreviation] [nvarchar](100) NOT NULL,
	[ContactCountryAbbreviation] [nvarchar](100) NOT NULL,
	[ContactSalutation] [nvarchar](100) NOT NULL,
	[ContactMobilePhone] [nvarchar](50) NOT NULL,
	[ContactAddressStreetLine1] [nvarchar](100) NOT NULL,
	[ContactAddressStreetLine2] [nvarchar](100) NOT NULL,
	[ContactAddressStreetLine3] [nvarchar](100) NOT NULL,
	[ContactAddressStreetLine4] [nvarchar](100) NOT NULL,
	[ContactFax] [nvarchar](50) NOT NULL,
	[ContactJobTitle] [nvarchar](100) NOT NULL,
	[ContactType] [nvarchar](40) NOT NULL,
	[ContactAddressPhone] [nvarchar](50) NOT NULL,
	[ContactPartnerCreatedByContact] [nvarchar](160) NOT NULL,
	[ContactPartnerModifiedByContact] [nvarchar](160) NOT NULL,
	[ContactAddressType] [nvarchar](256) NOT NULL,
	[ContactState] [nvarchar](4000) NOT NULL,
	[ContactAddressName] [nvarchar](200) NOT NULL,
	[ContactDescription] [nvarchar](max) NOT NULL,
	[ContactDepartment] [nvarchar](100) NOT NULL,
	[ContactRole] [nvarchar](256) NOT NULL,
	[ContactManager] [nvarchar](100) NOT NULL,
	[ContactManagerPhone] [nvarchar](50) NOT NULL,
	[ContactAssistant] [nvarchar](100) NOT NULL,
	[ContactAssistantPhone] [nvarchar](50) NOT NULL,
	[ContactGender] [nvarchar](256) NOT NULL,
	[ContactMaritalStatus] [nvarchar](256) NOT NULL,
	[ContactAnniversary] [date] NOT NULL,
	[ContactSpouse] [nvarchar](100) NOT NULL,
	[ContactPreferredContactMethod] [nvarchar](256) NOT NULL,
	[ContactAllowEmail] [nvarchar](256) NOT NULL,
	[ContactAllowBulkEmail] [nvarchar](256) NOT NULL,
	[ContactAllowPhone] [nvarchar](256) NOT NULL,
	[ContactAllowFax] [nvarchar](256) NOT NULL,
	[ContactAllowMail] [nvarchar](256) NOT NULL,
	[ContactAllowText] [nvarchar](256) NOT NULL,
	[ContactSendMarketingMaterials] [nvarchar](256) NOT NULL,
	[ContactLastDateIncludedInCampaign] [date] NOT NULL,
	[ContactFreightTerms] [nvarchar](256) NOT NULL,
	[ContactPreferredDay] [nvarchar](256) NOT NULL,
	[ContactPreferredTime] [nvarchar](256) NOT NULL,
	[ContactPreferredService] [nvarchar](160) NOT NULL,
	[ContactPreferredFacility/Equipment] [nvarchar](160) NOT NULL,
	[ContactPreferredUser] [nvarchar](200) NOT NULL,
	[ContactShippingMethod] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
