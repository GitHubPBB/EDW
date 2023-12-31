USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[FactComment]    Script Date: 12/5/2023 4:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[FactComment](
	[FactCommentId] [int] IDENTITY(1,1) NOT NULL,
	[CommentId] [uniqueidentifier] NOT NULL,
	[DimCommentId] [int] NOT NULL,
	[DimAccountId] [int] NOT NULL,
	[DimAccountCategoryId] [int] NOT NULL,
	[DimMembershipId] [int] NOT NULL,
	[DimCustomerProductId] [int] NOT NULL,
	[CreatedOn_DimDateId] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FactCommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
