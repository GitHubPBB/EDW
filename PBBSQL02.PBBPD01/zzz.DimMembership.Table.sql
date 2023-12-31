USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimMembership]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimMembership](
	[DimMembershipId] [int] IDENTITY(1,1) NOT NULL,
	[MembershipId] [int] NOT NULL,
	[MembershipCode] [varchar](13) NOT NULL,
	[MembershipType] [varchar](40) NOT NULL,
	[MembershipStatus] [varchar](1) NOT NULL,
	[MembershipGenerateForm1099] [tinyint] NOT NULL,
	[MembershipCertificateNumber] [varchar](13) NOT NULL,
	[MembershipLegalName] [varchar](50) NOT NULL,
	[MembershipExemptFromAllocation] [tinyint] NOT NULL,
	[MembershipExemptFromNotice] [tinyint] NOT NULL,
	[MembershipExemptFromPatronageWeighting] [tinyint] NOT NULL,
	[MembershipExemptFromRetirement] [tinyint] NOT NULL,
	[MembershipExemptFromStatementPrint] [tinyint] NOT NULL,
	[MembershipCancelledDate] [smalldatetime] NULL,
	[MembershipPayoutMethod] [varchar](1) NOT NULL,
	[MembershipEffectiveDate] [smalldatetime] NULL,
	[MembershipApplicationDate] [smalldatetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DimMembershipId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[MembershipId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
