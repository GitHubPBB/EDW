USE [PBBPACQ01]
GO
/****** Object:  User [QA]    Script Date: 12/5/2023 4:32:59 PM ******/
CREATE USER [QA] FOR LOGIN [QA] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [QA]
GO
