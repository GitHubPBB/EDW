USE [PBBPDW01]
GO
/****** Object:  Table [zzz].[_PBBResVideoExodus]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [zzz].[_PBBResVideoExodus](
	[Account_Type] [nvarchar](50) NOT NULL,
	[Account_Group_Code] [nvarchar](50) NOT NULL,
	[Account_Code] [int] NOT NULL,
	[Account_Name] [nvarchar](50) NOT NULL,
	[Cycle_Description] [nvarchar](50) NOT NULL,
	[Cycle_Number] [nvarchar](50) NOT NULL,
	[Account_Phone_Number] [nvarchar](50) NULL,
	[Account_EMail_Address] [nvarchar](50) NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Internal] [nvarchar](50) NOT NULL,
	[Courtesy] [nvarchar](50) NOT NULL,
	[Military] [nvarchar](50) NOT NULL,
	[Senior] [nvarchar](50) NOT NULL,
	[Point_Pause] [nvarchar](50) NOT NULL,
	[Has_Data] [nvarchar](50) NOT NULL,
	[Has_Data_Svc] [nvarchar](50) NOT NULL,
	[Has_Smart_Home] [nvarchar](50) NOT NULL,
	[Has_Smart_Home_Pod] [nvarchar](50) NOT NULL,
	[Has_Point_Guard] [nvarchar](50) NOT NULL,
	[Data_Category] [nvarchar](1) NULL,
	[Has_Cable] [nvarchar](50) NOT NULL,
	[Has_Cable_Svc] [nvarchar](50) NOT NULL,
	[Has_HBO] [nvarchar](50) NOT NULL,
	[Has_Cinemax] [nvarchar](50) NOT NULL,
	[Has_Showtime] [nvarchar](50) NOT NULL,
	[Has_Starz] [nvarchar](50) NOT NULL,
	[Cable_Category] [nvarchar](50) NULL,
	[Has_Phone] [nvarchar](50) NOT NULL,
	[Has_Phone_Svc] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
