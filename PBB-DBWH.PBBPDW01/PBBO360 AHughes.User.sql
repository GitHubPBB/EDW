USE [PBBPDW01]
GO
/****** Object:  User [PBBO360\AHughes]    Script Date: 12/5/2023 5:09:54 PM ******/
CREATE USER [PBBO360\AHughes] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [PBBO360\AHughes]
GO
ALTER ROLE [db_datareader] ADD MEMBER [PBBO360\AHughes]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [PBBO360\AHughes]
GO
