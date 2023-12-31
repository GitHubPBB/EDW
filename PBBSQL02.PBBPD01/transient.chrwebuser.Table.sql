USE [PBBPDW01]
GO
/****** Object:  Table [transient].[chrwebuser]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[chrwebuser](
	[CHRWebUserID] [int] NOT NULL,
	[AppID] [int] NOT NULL,
	[ClientID] [uniqueidentifier] NOT NULL,
	[Omnia360ContactID] [varchar](255) NULL,
	[CreatedByUser] [varchar](255) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[ModifiedByUser] [varchar](255) NULL,
	[ModifiedDateTime] [datetime2](0) NULL,
	[Username] [varchar](255) NULL,
	[PasswordHash] [varchar](max) NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[TermsAcceptanceDate] [datetime2](7) NULL,
	[RecordStatusID] [int] NOT NULL,
	[Email] [varchar](255) NULL,
	[SecurityStamp] [varchar](255) NULL,
	[PasswordSalt] [varchar](max) NULL,
	[PasswordHashAlgorithm] [varchar](56) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
