USE [PBBPSTG01]
GO
/****** Object:  User [HostedDB]    Script Date: 12/5/2023 5:05:27 PM ******/
CREATE USER [HostedDB] FOR LOGIN [HostedDB] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [HostedDB]
GO
