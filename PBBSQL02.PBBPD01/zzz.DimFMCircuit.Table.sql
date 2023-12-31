USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[DimFMCircuit]    Script Date: 12/5/2023 4:42:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[DimFMCircuit](
	[DimFMCircuitId] [int] IDENTITY(1,1) NOT NULL,
	[CIRCUIT_Id] [int] NOT NULL,
	[CircuitType] [nvarchar](50) NOT NULL,
	[CircuitLine] [int] NOT NULL,
	[CircuitStatus] [nvarchar](50) NOT NULL,
	[CircuitDescription] [nvarchar](50) NOT NULL,
	[CircuitComment] [nvarchar](255) NOT NULL,
	[CircuitConnectDate] [datetime] NULL,
	[CircuitDisconnectDate] [datetime] NULL,
	[CircuitCompany] [nvarchar](5) NOT NULL,
	[CircuitAlternateAccountName] [nvarchar](50) NOT NULL,
	[CircuitDropType] [nvarchar](15) NOT NULL,
	[CircuitDropSize] [nvarchar](15) NOT NULL,
	[CircuitDropGauge] [nvarchar](15) NOT NULL,
	[CircuitDropSpan] [nvarchar](15) NOT NULL,
	[CircuitTestDate] [datetime] NULL,
	[CircuitOriginalLineCurrent] [nvarchar](15) NOT NULL,
	[CircuitOriginalPowerInfluence] [nvarchar](15) NOT NULL,
	[CircuitOriginalGroundReading] [nvarchar](15) NOT NULL,
	[CircuitOriginalCircuitLoss] [nvarchar](15) NOT NULL,
	[CircuitOriginalCircuitNoise] [nvarchar](15) NOT NULL,
	[CircuitOriginalBalance] [nvarchar](15) NOT NULL,
	[CircuitCurrentLineCurrent] [nvarchar](15) NOT NULL,
	[CircuitCurrentPowerInfluence] [nvarchar](15) NOT NULL,
	[CircuitCurrentGroundReading] [nvarchar](15) NOT NULL,
	[CircuitCurrentCircuitLoss] [nvarchar](15) NOT NULL,
	[CircuitCurrentCircuitNoise] [nvarchar](15) NOT NULL,
	[CircuitCurrentBalance] [nvarchar](15) NOT NULL,
	[CircuitLineCoding] [nvarchar](15) NOT NULL,
	[CircuitGrade] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DimFMCircuitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CIRCUIT_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
