USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactCase]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactCase](
	[FactCaseId] [int] IDENTITY(1,1) NOT NULL,
	[IncidentId] [nvarchar](400) NOT NULL,
	[DimCaseId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimServiceLocationId] [int] NOT NULL,
	[DimFMAddressId] [int] NOT NULL,
	[Responsible_DimContactId] [int] NOT NULL,
	[DimCustomerItemId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[ParentChild_DimCaseId] [int] NOT NULL,
	[DimFMCircuitId] [int] NOT NULL,
	[DimExternalNotesId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactCaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
