USE [PBBPACQ01]
GO
/****** Object:  User [mgview]    Script Date: 12/5/2023 4:32:59 PM ******/
CREATE USER [mgview] FOR LOGIN [mgview] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [mgview]
GO
