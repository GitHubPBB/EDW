USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactComponentAttribute]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactComponentAttribute](
	[FactComponentAttributeId] [int] IDENTITY(1,1) NOT NULL,
	[DimComponentAttributeId] [int] NOT NULL,
	[DimComponentId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactComponentAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
