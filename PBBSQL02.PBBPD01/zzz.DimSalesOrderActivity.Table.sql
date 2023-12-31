USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimSalesOrderActivity]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimSalesOrderActivity](
	[DimSalesOrderActivityId] [int] IDENTITY(1,1) NOT NULL,
	[ActivityId] [uniqueidentifier] NOT NULL,
	[SalesOrderActivitySubject] [nvarchar](200) NOT NULL,
	[SalesOrderActivityOwner] [nvarchar](200) NOT NULL,
	[SalesOrderActivityPriority] [int] NOT NULL,
	[SalesOrderActivityStartDate] [datetime] NOT NULL,
	[SalesOrderActivityDueDate] [datetime] NOT NULL,
	[SalesOrderActivityCreatedOn] [datetime] NOT NULL,
	[SalesOrderActivityCloseDate] [datetime] NOT NULL,
	[SalesOrderActivityModifiedBy] [nvarchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimSalesOrderActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
