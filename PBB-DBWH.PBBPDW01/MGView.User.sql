USE [PBBPDW01]
GO
/****** Object:  User [MGView]    Script Date: 12/5/2023 5:09:54 PM ******/
CREATE USER [MGView] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [MGView]
GO
ALTER ROLE [db_datareader] ADD MEMBER [MGView]
GO
