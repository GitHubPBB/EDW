USE [PBBPACQ01]
GO
/****** Object:  User [ROOT\alan.hughes]    Script Date: 12/5/2023 4:32:59 PM ******/
CREATE USER [ROOT\alan.hughes] FOR LOGIN [ROOT\alan.hughes] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [ROOT\alan.hughes]
GO
