USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimFMPort]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimFMPort](
	[DimFMPortId] [int] IDENTITY(1,1) NOT NULL,
	[PORT_Id] [int] NOT NULL,
	[PortName] [nvarchar](50) NOT NULL,
	[PortNumber] [int] NOT NULL,
	[PortStatus] [nvarchar](15) NOT NULL,
	[PortType] [nvarchar](50) NOT NULL,
	[PortComment] [nvarchar](50) NOT NULL,
	[PortTemplateName] [nvarchar](50) NOT NULL,
	[PortAreaCode] [nvarchar](3) NOT NULL,
	[PortAssigNum] [nvarchar](8) NOT NULL,
	[PortOldAssignNum] [nvarchar](10) NOT NULL,
	[PortDrawName] [nvarchar](100) NOT NULL,
	[PortHandle] [nvarchar](50) NOT NULL,
	[PortXLoc] [float] NOT NULL,
	[PortYLoc] [float] NOT NULL,
	[PortTechnician] [nvarchar](50) NOT NULL,
	[PortDirection] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimFMPortId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[PORT_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
