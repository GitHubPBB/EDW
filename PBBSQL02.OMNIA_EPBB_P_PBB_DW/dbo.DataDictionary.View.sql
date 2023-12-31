USE [OMNIA_EPBB_P_PBB_DW]
GO
/****** Object:  View [dbo].[DataDictionary]    Script Date: 12/5/2023 3:30:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DataDictionary]
AS
SELECT 
	Sys_Tables.[name] AS TableName,
	Sys_Cols.[name] AS ColumnName,
	Sys_Types.[name] AS DataType,
	CASE Sys_Cols.max_length
		WHEN -1
			THEN 'max'
		ELSE ISNULL(
				CONVERT(VARCHAR(10), Sch_Cols.CHARACTER_MAXIMUM_LENGTH), '(' 
				+ CONVERT(VARCHAR(10), Sch_Cols.NUMERIC_PRECISION) + ',' 
				+ CONVERT(VARCHAR(10), Sch_Cols.NUMERIC_SCALE) + ')'
			)
	END AS [MaxLength],
	TableDescriptions.[value] AS TableDescription,
	Descriptions.[value] AS ColumnDescription
FROM sys.columns AS Sys_Cols
   INNER JOIN Sys.Tables AS Sys_Tables
      ON Sys_Cols.[object_id] = Sys_Tables.[object_id]
   INNER JOIN Sys.Schemas AS Sys_Schema
      ON Sys_Tables.[schema_id] = Sys_Schema.[schema_id]
   INNER JOIN Sys.Types AS Sys_Types
      ON Sys_Cols.[user_type_id] = Sys_Types.[user_type_id]
   LEFT JOIN Sys.Extended_Properties AS Descriptions
      ON Descriptions.[major_id] = Sys_Cols.[object_id]
         AND Descriptions.[minor_id] = Sys_Cols.[column_id]
         AND Descriptions.[class] = 1
         AND Descriptions.[name] = 'Description'
   LEFT JOIN Sys.Extended_Properties AS TableDescriptions
      ON TableDescriptions.[major_id] = Sys_Tables.[object_id]
         AND TableDescriptions.[minor_id] = 0
         AND TableDescriptions.[class] = 1
         AND TableDescriptions.[name] = 'Description'
   INNER JOIN INFORMATION_SCHEMA.COLUMNS AS Sch_Cols
      ON Sys_Schema.[name] = Sch_Cols.[TABLE_SCHEMA]
         AND Sys_Tables.[name] = Sch_Cols.[TABLE_NAME]
         AND Sys_Cols.[name] = Sch_Cols.[COLUMN_NAME]
   LEFT JOIN Sys.Views AS Sys_Views
      ON CASE 
            WHEN Sys_Tables.[name] LIKE 'Dim%'
               THEN SUBSTRING(Sys_Tables.[name], 4, 125)
            WHEN Sys_Tables.[name] LIKE 'Fact%'
               THEN SUBSTRING(Sys_Tables.[name], 5, 124)
            ELSE Sys_Tables.[name]
         END = Sys_Views.[name]
   LEFT JOIN Sys.Columns AS Sys_ViewCols
      ON Sys_Views.[object_id] = Sys_ViewCols.[object_id]
         AND 
         CASE 
            WHEN Sys_Tables.[name] LIKE 'Dim%'
               AND Sys_Cols.[name] = 'Id'
                  THEN SUBSTRING(Sys_Tables.[name], 4, 125) + '_Id'
            WHEN Sys_Tables.[name] LIKE 'Fact%'
               AND Sys_Cols.[name] LIKE '%_Id'
               AND (
                  Sys_Cols.[name] LIKE 'Dim%'
                  OR Sys_Cols.[name] LIKE '%_Dim%'
                  )
               AND Sys_Cols.[name] NOT LIKE 'Dim' + SUBSTRING(Sys_Tables.[name], 5, 124) + '_Id'
                  THEN REPLACE(Sys_Cols.[name], 'Dim', '')
            ELSE Sys_Cols.[name]
         END = Sys_ViewCols.[name]
GO
