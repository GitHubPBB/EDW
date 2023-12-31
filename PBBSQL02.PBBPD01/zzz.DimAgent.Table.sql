USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimAgent]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimAgent](
	[DimAgentId] [int] IDENTITY(1,1) NOT NULL,
	[chr_AgentId] [nvarchar](400) NOT NULL,
	[AgentStatus] [nvarchar](256) NOT NULL,
	[AgentName] [nvarchar](100) NOT NULL,
	[AgentParentName] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimAgentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
