USE [PBBPDW01]
GO
/****** Object:  User [PBBO360\Domain Users]    Script Date: 12/5/2023 5:09:54 PM ******/
CREATE USER [PBBO360\Domain Users]
GO
ALTER ROLE [db_datareader] ADD MEMBER [PBBO360\Domain Users]
GO
