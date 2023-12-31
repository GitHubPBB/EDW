USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimComponentAttribute]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimComponentAttribute](
	[DimComponentAttributeId] [int] IDENTITY(1,1) NOT NULL,
	[ItemDataId] [int] NOT NULL,
	[ItemData] [varchar](255) NOT NULL,
	[StartDate] [smalldatetime] NULL,
	[AttributeCode] [varchar](40) NOT NULL,
	[Attribute] [varchar](40) NOT NULL,
	[AttributeDefault] [varchar](40) NOT NULL,
	[AttributeClass] [varchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimComponentAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ItemDataId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
