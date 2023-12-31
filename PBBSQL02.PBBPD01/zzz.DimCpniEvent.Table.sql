USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimCpniEvent]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimCpniEvent](
	[DimCpniEventId] [int] IDENTITY(1,1) NOT NULL,
	[chr_AccountCPNIEventScreenId] [nvarchar](400) NOT NULL,
	[CpniEventCreationDate] [datetime] NULL,
	[CpniEventCreatedByUserName] [nvarchar](200) NOT NULL,
	[CpniVerificationMethodCode] [nvarchar](20) NOT NULL,
	[CpniVerificationMethodDescription] [nvarchar](256) NOT NULL,
	[CpniEventCode] [nvarchar](20) NOT NULL,
	[CpniEventCodeDescription] [nvarchar](256) NOT NULL,
	[CpniEventScreen] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCpniEventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[chr_AccountCPNIEventScreenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
