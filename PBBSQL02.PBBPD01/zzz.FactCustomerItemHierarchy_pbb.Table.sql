USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactCustomerItemHierarchy_pbb]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactCustomerItemHierarchy_pbb](
	[FactCustomerItemHierarchyId] [int] IDENTITY(1,1) NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimCatalogItemId] [int] NOT NULL,
	[AccountID] [int] NULL,
	[LocationID] [int] NULL,
	[ItemID] [int] NULL,
	[ParentItemID] [int] NULL,
	[PWBParentItemID] [int] NULL,
	[RootItemID] [int] NULL,
	[ItemQuantity] [int] NULL,
	[ItemPrice] [money] NULL,
	[ServiceID] [int] NULL,
	[ComponentID] [int] NULL,
	[ComponentVersion] [smallint] NULL,
	[ComponentClassID] [int] NULL,
	[ActivationDate] [smalldatetime] NULL,
	[DeactivationDate] [smalldatetime] NULL,
	[ItemStatus] [char](1) NULL,
	[DisplayName] [varchar](255) NULL,
	[sortorder] [varchar](max) NULL,
	[HierarchyLevel] [int] NULL,
 CONSTRAINT [PK_FactCustomerItemHierarchy_pbb] PRIMARY KEY CLUSTERED 
(
	[FactCustomerItemHierarchyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
