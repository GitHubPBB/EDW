USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[PBB_IncrementalLoadCompletion]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[PBB_IncrementalLoadCompletion](
	[CompletionDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_PBB_IncrementalLoadCompletion] PRIMARY KEY CLUSTERED 
(
	[CompletionDateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
