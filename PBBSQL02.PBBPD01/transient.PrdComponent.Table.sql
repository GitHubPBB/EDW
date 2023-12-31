USE [PBBPDW01]
GO
/****** Object:  Table [transient].[PrdComponent]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [transient].[PrdComponent](
	[ComponentID] [int] NOT NULL,
	[Version] [smallint] NOT NULL,
	[ModifyDate] [smalldatetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[ComponentCode] [char](7) NOT NULL,
	[Component] [varchar](40) NOT NULL,
	[ComponentMaxQuantity] [int] NOT NULL,
	[ComponentMinQuantity] [int] NOT NULL,
	[UnitOfMeasureID] [int] NOT NULL,
	[ComponentClassID] [int] NOT NULL,
	[ComponentTypeID] [int] NULL,
	[PICCClassID] [int] NULL,
	[PrintOnTrouble] [smallint] NOT NULL,
	[ComponentWeight] [int] NULL,
	[ImageID] [int] NULL,
	[DefaultPrice] [money] NOT NULL,
	[DefaultCost] [money] NOT NULL,
	[Remarks] [varchar](8000) NULL,
	[PricingIsRequired] [tinyint] NULL,
	[OrderVisible] [tinyint] NULL,
	[IsMultInstance] [tinyint] NULL,
	[IsProduct] [tinyint] NULL,
	[ImageFileName] [nvarchar](512) NULL,
	[IsPlant] [tinyint] NULL,
	[IsCPE] [tinyint] NULL,
	[CPEClassID] [int] NULL,
	[EquipmentTypeID] [int] NULL,
 CONSTRAINT [XPKPrdComponent] PRIMARY KEY NONCLUSTERED 
(
	[ComponentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
