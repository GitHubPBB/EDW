USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimTax]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimTax](
	[DimTaxId] [int] IDENTITY(1,1) NOT NULL,
	[TaxId] [int] NOT NULL,
	[TaxName] [varchar](40) NOT NULL,
	[TaxQualificationMethod] [char](1) NOT NULL,
	[TaxJurisdiction] [char](40) NOT NULL,
	[TaxJurisdictionCode] [char](7) NOT NULL,
	[TaxJurisdictionE911Suppress] [tinyint] NOT NULL,
	[TaxJuristictionClass] [char](40) NOT NULL,
	[TaxAuthorityCode] [char](7) NOT NULL,
	[TaxAuthority] [varchar](40) NOT NULL,
	[TaxClass] [char](40) NOT NULL,
	[TaxChargeTypeCode] [char](7) NOT NULL,
	[TaxChargeType] [varchar](40) NOT NULL,
	[TaxChargeClass] [char](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimTaxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[TaxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
