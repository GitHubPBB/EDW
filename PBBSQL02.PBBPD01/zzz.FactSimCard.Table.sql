USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactSimCard]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactSimCard](
	[FactSimCardId] [int] IDENTITY(1,1) NOT NULL,
	[SIMCardID] [int] NOT NULL,
	[DimSimCardId] [int] NOT NULL,
	[DimPhoneId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactSimCardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
