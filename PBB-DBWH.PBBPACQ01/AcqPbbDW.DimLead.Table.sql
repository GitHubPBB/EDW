USE [PBBPACQ01]
GO
/****** Object:  Table [AcqPbbDW].[DimLead]    Script Date: 12/5/2023 4:33:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AcqPbbDW].[DimLead](
	[DimLeadId] [int] NOT NULL,
	[LeadId] [uniqueidentifier] NOT NULL,
	[LeadSource] [nvarchar](256) NOT NULL,
	[LeadIndustry] [nvarchar](256) NOT NULL,
	[LeadPreferredContactMethod] [nvarchar](256) NOT NULL,
	[LeadSalesStage] [nvarchar](256) NOT NULL,
	[LeadTopic] [nvarchar](300) NOT NULL,
	[LeadEstimatedCloseDate] [datetime] NULL,
	[LeadCompany] [nvarchar](100) NOT NULL,
	[LeadName] [nvarchar](160) NOT NULL,
	[LeadNumberOfEmployees] [int] NOT NULL,
	[LeadSICCode] [nvarchar](20) NOT NULL,
	[LeadEmailAddress] [nvarchar](100) NOT NULL,
	[LeadJobTitle] [nvarchar](100) NOT NULL,
	[LeadBusinessPhone] [nvarchar](50) NOT NULL,
	[LeadMobilePhone] [nvarchar](20) NOT NULL,
	[LeadStatus] [nvarchar](256) NOT NULL,
	[LeadStatusReason] [nvarchar](256) NOT NULL,
	[LeadOwner] [nvarchar](200) NOT NULL,
	[LeadOwnerType] [nvarchar](4) NOT NULL,
	[LeadAddressStateAbbreviation] [nvarchar](6) NOT NULL,
	[LeadAddressState] [nvarchar](50) NOT NULL,
	[LeadAddressCountry] [nvarchar](4000) NOT NULL,
	[LeadAllowEmail] [nvarchar](256) NOT NULL,
	[LeadAllowBulkEmail] [nvarchar](256) NOT NULL,
	[LeadAllowPhone] [nvarchar](256) NOT NULL,
	[LeadAllowMail] [nvarchar](256) NOT NULL,
	[LeadAddressStreet1] [nvarchar](4000) NOT NULL,
	[LeadAddressStreet2] [nvarchar](4000) NOT NULL,
	[LeadAddressStreet3] [nvarchar](4000) NOT NULL,
	[LeadAddressCity] [nvarchar](4000) NOT NULL,
	[LeadAddressPostalCode] [nvarchar](4000) NOT NULL,
	[LeadDescription] [nvarchar](max) NOT NULL,
	[LeadSendMarketingMaterials] [nvarchar](256) NOT NULL,
	[LeadLastUsedInCampaign] [datetime] NULL,
	[LeadRating] [nvarchar](256) NOT NULL,
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL,
	[MetaEffectiveStartDatetime] [datetime] NOT NULL,
	[MetaEffectiveEndDatetime] [datetime] NOT NULL,
	[MetaCurrentRecordIndicator] [varchar](1) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadSource]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadIndustry]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadPreferredContactMethod]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadSalesStage]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadTopic]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadCompany]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadName]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ((0)) FOR [LeadNumberOfEmployees]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadSICCode]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadEmailAddress]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadJobTitle]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadBusinessPhone]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadMobilePhone]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadStatus]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadStatusReason]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadOwner]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadOwnerType]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAddressStateAbbreviation]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAddressState]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAddressCountry]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAllowEmail]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAllowBulkEmail]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAllowPhone]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAllowMail]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAddressStreet1]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAddressStreet2]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAddressStreet3]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAddressCity]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadAddressPostalCode]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadDescription]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadSendMarketingMaterials]
GO
ALTER TABLE [AcqPbbDW].[DimLead] ADD  DEFAULT ('') FOR [LeadRating]
GO
