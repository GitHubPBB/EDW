USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimComment]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimComment](
	[DimCommentId] [int] IDENTITY(1,1) NOT NULL,
	[CommentId] [uniqueidentifier] NOT NULL,
	[CommentType] [varchar](15) NOT NULL,
	[CommentCreatedOn] [datetime] NULL,
	[CommentDescription] [nvarchar](max) NOT NULL,
	[CommentCreatedBy] [nvarchar](200) NOT NULL,
	[CommentCode] [nvarchar](50) NOT NULL,
	[CommentCodeDescription] [varchar](100) NOT NULL,
	[Comments] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimCommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
