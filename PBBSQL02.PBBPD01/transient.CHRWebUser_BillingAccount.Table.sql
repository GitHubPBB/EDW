USE [PBBPDW01]
GO
/****** Object:  Table [transient].[CHRWebUser_BillingAccount]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[CHRWebUser_BillingAccount](
	[CHRWebUserID] [int] NOT NULL,
	[BillingAccountID] [varchar](255) NOT NULL,
	[IsHomeBillingAccountID] [bit] NOT NULL,
	[CreatedByUser] [varchar](255) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[ModifiedByUser] [varchar](255) NULL,
	[ModifiedDateTime] [datetime2](0) NULL,
	[IsIdentityVerified] [bit] NULL,
	[IsCreditVerified] [bit] NULL,
	[VerificationDate] [datetime2](7) NULL
) ON [PRIMARY]
GO
