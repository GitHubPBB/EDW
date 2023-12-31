USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimDate]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimDate](
	[DimDateId] [date] NOT NULL,
	[Name] [nvarchar](29) NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[MonthName] [nvarchar](9) NOT NULL,
	[DayOfYear] [int] NOT NULL,
	[DayOfMonth] [int] NOT NULL,
	[MonthOfYear] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimDateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
