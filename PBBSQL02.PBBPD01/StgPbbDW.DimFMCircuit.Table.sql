USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbDW].[DimFMCircuit]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbDW].[DimFMCircuit](
	[DimFMCircuitId] [int] NOT NULL,
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
	[MetaRowKey] [varchar](2000) NOT NULL,
	[MetaRowKeyFields] [varchar](2000) NOT NULL,
	[MetaRowHash] [varbinary](200) NOT NULL,
	[MetaSourceSystemCode] [varchar](100) NOT NULL,
	[MetaInsertDateTime] [datetime] NOT NULL,
	[MetaUpdateDateTime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitType]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ((0)) FOR [CircuitLine]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitStatus]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitDescription]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitComment]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitCompany]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitAlternateAccountName]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitDropType]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitDropSize]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitDropGauge]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitDropSpan]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitOriginalLineCurrent]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitOriginalPowerInfluence]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitOriginalGroundReading]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitOriginalCircuitLoss]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitOriginalCircuitNoise]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitOriginalBalance]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitCurrentLineCurrent]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitCurrentPowerInfluence]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitCurrentGroundReading]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitCurrentCircuitLoss]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitCurrentCircuitNoise]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitCurrentBalance]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitLineCoding]
GO
ALTER TABLE [StgPbbDW].[DimFMCircuit] ADD  DEFAULT ('') FOR [CircuitGrade]
GO
