USE [PBBPDW01]
GO
/****** Object:  Table [transient].[chr_workorder]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[chr_workorder](
	[CreatedByName] [nvarchar](200) NULL,
	[CreatedByYomiName] [nvarchar](200) NULL,
	[CreatedOnBehalfByName] [nvarchar](200) NULL,
	[CreatedOnBehalfByYomiName] [nvarchar](200) NULL,
	[ModifiedByName] [nvarchar](200) NULL,
	[ModifiedByYomiName] [nvarchar](200) NULL,
	[ModifiedOnBehalfByName] [nvarchar](200) NULL,
	[ModifiedOnBehalfByYomiName] [nvarchar](200) NULL,
	[cus_BuildingName] [nvarchar](100) NULL,
	[chr_PointofContactIdYomiName] [nvarchar](200) NULL,
	[chr_PointofContactIdName] [nvarchar](200) NULL,
	[cus_DistributionCenterName] [nvarchar](200) NULL,
	[chr_CloseByIdName] [nvarchar](200) NULL,
	[chr_WorkOrderTypeIdName] [nvarchar](100) NULL,
	[chr_CloseByIdYomiName] [nvarchar](200) NULL,
	[OrganizationIdName] [nvarchar](160) NULL,
	[chr_ServiceOrderIdName] [nvarchar](256) NULL,
	[chr_WOCloseCodeIdName] [nvarchar](100) NULL,
	[chr_workorderId] [uniqueidentifier] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[OrganizationId] [uniqueidentifier] NULL,
	[statecode] [int] NOT NULL,
	[statuscode] [int] NULL,
	[VersionNumber] [timestamp] NULL,
	[ImportSequenceNumber] [int] NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[chr_name] [nvarchar](100) NULL,
	[chr_CloseById] [uniqueidentifier] NULL,
	[chr_CloseComments] [nvarchar](max) NULL,
	[chr_ClosedOn] [datetime] NULL,
	[chr_Description] [nvarchar](max) NULL,
	[chr_DueDate] [datetime] NULL,
	[chr_PointofContactId] [uniqueidentifier] NULL,
	[chr_ServiceOrderId] [uniqueidentifier] NULL,
	[chr_WO_Number] [nvarchar](30) NULL,
	[chr_WOCloseCodeId] [uniqueidentifier] NULL,
	[chr_WOCloseReason] [int] NULL,
	[chr_WorkOrderTypeId] [uniqueidentifier] NULL,
	[cus_ServiceableDate] [datetime] NULL,
	[cus_Building] [uniqueidentifier] NULL,
	[cus_CompetitiveType] [int] NULL,
	[cus_DistributionCenter] [uniqueidentifier] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
