USE [PBBPACQ01]
GO
/****** Object:  User [HostedDB]    Script Date: 12/5/2023 4:32:59 PM ******/
CREATE USER [HostedDB] FOR LOGIN [HostedDB] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [HostedDB]
GO
