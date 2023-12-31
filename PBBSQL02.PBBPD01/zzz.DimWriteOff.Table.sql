USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimWriteOff]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimWriteOff](
	[DimWriteOffId] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [varchar](256) NOT NULL,
	[WriteOffTemplate] [varchar](40) NOT NULL,
	[WriteOffStatus] [varchar](16) NOT NULL,
	[WriteOffClass] [varchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimWriteOffId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
