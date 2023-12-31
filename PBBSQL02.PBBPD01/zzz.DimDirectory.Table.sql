USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimDirectory]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimDirectory](
	[DimDirectoryId] [int] IDENTITY(1,1) NOT NULL,
	[DirectoryListingID] [int] NOT NULL,
	[PhoneDirectoryLine] [int] NOT NULL,
	[ListingEffectiveDate] [smalldatetime] NULL,
	[LocalWhitePageListing] [char](1) NOT NULL,
	[DirectoryAssistanceListing] [char](1) NOT NULL,
	[ListingPrintPhoneNumber] [char](1) NOT NULL,
	[ListingBold] [char](1) NOT NULL,
	[ListingItalic] [char](1) NOT NULL,
	[Listing] [varchar](70) NOT NULL,
	[ListingFirstName] [varchar](30) NOT NULL,
	[ListingSuffix] [varchar](20) NOT NULL,
	[ListingTitle] [varchar](20) NOT NULL,
	[DirectoryStreet] [varchar](55) NOT NULL,
	[ListingUnderline] [char](1) NOT NULL,
	[DirectoryListingSort] [varchar](60) NOT NULL,
	[ListingSortPrimary] [varchar](70) NOT NULL,
	[ListingSortSecondary] [varchar](70) NOT NULL,
	[DirectoryListingPhone] [char](14) NOT NULL,
	[DirectoryClass] [varchar](40) NOT NULL,
	[DirectoryPostalCode] [char](11) NOT NULL,
	[DirectoryCity] [char](28) NOT NULL,
	[DirectoryState] [varchar](50) NOT NULL,
	[DirectoryStateAbbreviation] [char](6) NOT NULL,
	[DirectoryCountry] [varchar](50) NOT NULL,
	[DirectoryCountryAbbreviation] [char](6) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimDirectoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DirectoryListingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
