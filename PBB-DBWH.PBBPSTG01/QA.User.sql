USE [PBBPSTG01]
GO
/****** Object:  User [QA]    Script Date: 12/5/2023 5:05:29 PM ******/
CREATE USER [QA] FOR LOGIN [QA] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [QA]
GO
