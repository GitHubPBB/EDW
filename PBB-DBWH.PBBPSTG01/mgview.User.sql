USE [PBBPSTG01]
GO
/****** Object:  User [mgview]    Script Date: 12/5/2023 5:05:29 PM ******/
CREATE USER [mgview] FOR LOGIN [mgview] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [mgview]
GO
